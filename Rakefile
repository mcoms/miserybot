# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'

require_relative 'lib/slack_client'
require_relative 'lib/summariser'
require_relative 'lib/web_client'

Dotenv.load '.env.local', '.env'
require_relative 'lib/config'

task default: %w[post]

desc 'Get the latest summary and post it to the channel'
task :post do
  records = WebClient.new(DATA_URL).fetch_records
  summary = Summariser.new(records).to_s
  puts summary
  SlackClient.new(SLACK_API_TOKEN, SLACK_CHANNEL, SLACK_THREAD_TS).post_message(summary)
end
