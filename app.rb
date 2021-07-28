# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
require 'logger'
require 'rufus-scheduler'

require_relative 'lib/slack_client'
require_relative 'lib/summariser'
require_relative 'lib/web_client'

Dotenv.load('.env.local', '.env')

DATA_URL = 'https://api.coronavirus.data.gov.uk/v2/data?areaType=overview&metric=newAdmissions&metric=newCasesByPublishDate&metric=newDeaths28DaysByPublishDate&metric=newVirusTests&metric=newVaccinesGivenByPublishDate&format=json'
SLACK_API_TOKEN = ENV.fetch 'SLACK_API_TOKEN'
SLACK_CHANNEL = ENV.fetch 'SLACK_CHANNEL'

$stdout.sync = true
logger = Logger.new($stdout)
scheduler = Rufus::Scheduler.new

scheduler.cron '16 15 * * * Europe/London', overlap: false, timeout: '2m' do
  records = WebClient.new(DATA_URL).fetch_records
  summary = Summariser.new(records).to_s
  logger.debug summary
  SlackClient.new(SLACK_API_TOKEN, SLACK_CHANNEL).post_message(summary)
end

logger.info "Configured with token #{SLACK_API_TOKEN[0...5]}... and channel #{SLACK_CHANNEL}"
logger.info 'Joining scheduler'
scheduler.join
logger.info 'Scheduler exited'
