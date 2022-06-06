# frozen_string_literal: true

DATA_URL = 'https://api.coronavirus.data.gov.uk/v2/data?areaType=nation&areaCode=E92000001&metric=newAdmissions&metric=newCasesByPublishDate&metric=newDeaths28DaysByPublishDate&metric=newVirusTestsByPublishDate&metric=newVaccinesGivenByPublishDate&format=json'
CRON_SCHEDULE = ENV.fetch 'CRON_SCHEDULE', '15 16 * * * Europe/London'
SLACK_API_TOKEN = ENV.fetch 'SLACK_API_TOKEN'
SLACK_CHANNEL = ENV.fetch 'SLACK_CHANNEL'
SLACK_THREAD_TS = ENV.fetch 'SLACK_THREAD_TS', nil
SCHEDULER_TIMEOUT = ENV.fetch 'SCHEDULER_TIMEOUT', '10m'
SCHEDULER_TRIES = ENV.fetch('SCHEDULER_TRIES', '5').to_i
SCHEDULER_BASE_INTERVAL = ENV.fetch('SCHEDULER_BASE_INTERVAL', '20').to_i
FARADAY_TIMEOUT = ENV.fetch('FARADAY_TIMEOUT', '10').to_i
