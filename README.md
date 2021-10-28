# miserybot

Gets the [latest UK Coronavirus stats](https://coronavirus.data.gov.uk/) and posts them to Slack each day at 4:15pm, which is just after they're released.

## Running

Get a [User OAuth Token from Slack](https://api.slack.com/apps) by creating an app, giving it the `chat:write` User Token Scope, and installing it to your workspace. This app will post messages as you.

It should work if you use the Bot Token and Bot Token Scope for your app (and post as itself) but I haven't tested it.

```sh
docker run --rm \
  -e SLACK_API_TOKEN='abc123...' \
  -e SLACK_CHANNEL='#covid-updates' \
  ghcr.io/mcoms/miserybot:latest
```

The app starts a long-running process which waits until 4:15pm then gets the latest numbers and posts them to the channel you specified:

```
Latest UK numbers (daily):
- 23,511 cases (27/Jul)
- 945 admitted (22/Jul)
- 131 deaths (27/Jul)
- 810,459 tests (26/Jul)
- 236,261 vaccines (26/Jul)
#miseryBot
```

### Environment variables

You can configure the app by setting some environment variables.

| Variable | Required? | Example | Usage |
| :-- | :-: | :-- | :-- |
| `SLACK_API_TOKEN` | **_required_** | `xoxp-1234...` | Get a [User OAuth Token from Slack](https://api.slack.com/apps) by creating an app, giving it the `chat:write` User Token Scope, and installing it to your workspace. |
| `SLACK_CHANNEL` | **_required_** | `#covid-updates` | The channel name or Slack channel ID of the channel to post messages to. |
| `SLACK_THREAD_TS` | _optional_ | `1627405147.101100` | If you'd like to reply to a thread, include the TS value here. You can get this as part of the URL by copying the link to an existing message in Slack. The app will then thread its messages but will still broadcast them to the channel. Threading is a handy way to see previous stats in one place in order to spot trends. |
| `CRON_SCHEDULE` | _optional_ | `15 16 * * * Europe/London` | When to get stats (cron syntax with optional timezone) |
| `SCHEDULER_TIMEOUT` | _optional_ | `10m` | The total amount of time retrieving the stats is allowed to take before giving up. |
| `SCHEDULER_TRIES` | _optional_ | `5` | The maximum number of times to try and retrieve stats each day (a server error will retry with exponential back-off). |
| `SCHEDULER_BASE_INTERVAL` | _optional_ | `20` | The initial interval in seconds between tries. |
| `FARADAY_TIMEOUT` | _optional_ | `10` | The number of seconds to try connecting, reading, writing to a HTTP connection before raising a timeout error. |

## Development

### Running locally

```sh
cp .env .env.local
# Put your Slack token etc. in .env.local
bundle install
ruby app.rb
```

### Running in Docker

```sh
docker build -t miserybot .
docker run --rm \
  -e SLACK_API_TOKEN='abc123...' \
  -e SLACK_CHANNEL='#covid-updates' \
  miserybot
```

### Testing

A nice PR for this project would be to write some tests using [minitest](https://github.com/seattlerb/minitest).

## Legalese

This project adopts the [MIT License](LICENSE) and the [No Code of Conduct](CODE_OF_CONDUCT.md). The default branch is `master`. Contains public sector information licensed under the [Open Government Licence v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
