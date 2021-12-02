# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
require 'logger'
require 'retriable'
require 'rufus-scheduler'

require_relative 'lib/slack_client'
require_relative 'lib/summariser'
require_relative 'lib/web_client'

Dotenv.load('.env.local', '.env')

DATA_URL = 'https://api.coronavirus.data.gov.uk/v2/data?areaType=overview&metric=newAdmissions&metric=newCasesByPublishDate&metric=newDeaths28DaysByPublishDate&metric=newVirusTestsByPublishDate&metric=newVaccinesGivenByPublishDate&format=json'
CRON_SCHEDULE = ENV.fetch 'CRON_SCHEDULE', '15 16 * * * Europe/London'
SLACK_API_TOKEN = ENV.fetch 'SLACK_API_TOKEN'
SLACK_CHANNEL = ENV.fetch 'SLACK_CHANNEL'
SLACK_THREAD_TS = ENV.fetch 'SLACK_THREAD_TS', nil
SCHEDULER_TIMEOUT = ENV.fetch 'SCHEDULER_TIMEOUT', '10m'
SCHEDULER_TRIES = ENV.fetch('SCHEDULER_TRIES', '5').to_i
SCHEDULER_BASE_INTERVAL = ENV.fetch('SCHEDULER_BASE_INTERVAL', '20').to_i
FARADAY_TIMEOUT = ENV.fetch('FARADAY_TIMEOUT', '10').to_i

$stdout.sync = true
logger = Logger.new($stdout)
scheduler = Rufus::Scheduler.new
on_retry = proc do |exception|
  logger.warn "Retrying due to #{exception.class}: '#{exception.message}'"
end

scheduler.cron(CRON_SCHEDULE, overlap: false, timeout: SCHEDULER_TIMEOUT) do |job|
  Retriable.retriable(on: [Faraday::ServerError, Faraday::ConnectionFailed], on_retry: on_retry,
                      tries: SCHEDULER_TRIES, base_interval: SCHEDULER_BASE_INTERVAL) do
    records = WebClient.new(DATA_URL, timeout: FARADAY_TIMEOUT).fetch_records
    summary = Summariser.new(records).to_s
    logger.debug summary
    SlackClient.new(SLACK_API_TOKEN, SLACK_CHANNEL, SLACK_THREAD_TS).post_message(summary)
  end
  logger.debug "Next run will be at #{job.next_time.iso8601}"
end

logger.info "Configured with token #{SLACK_API_TOKEN[0...5]}... and channel #{SLACK_CHANNEL}"
logger.info "Will thread messages under #{SLACK_THREAD_TS}" if SLACK_THREAD_TS
logger.debug "First job will run at #{scheduler.jobs.first.next_time.iso8601}"
logger.info 'Joining scheduler'
scheduler.join
logger.info 'Scheduler exited'
