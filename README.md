# miserybot

Gets the latest UK Coronavirus stats and posts them to Slack each day at 6:15pm, which is just after they're released.

## Running

Get a [User OAuth Token from Slack](https://api.slack.com/apps) by creating an app, giving it the `chat:write` User Token Scope, and installing it to your workspace. This app will post messages as you.

It should work if you use the Bot Token and Bot Token Scope for your app (and post as itself) but I haven't tested it.

```sh
docker build -t miserybot .
docker run --rm -t -e SLACK_API_TOKEN=abc123... -e SLACK_CHANNEL=#covid-updates miserybot
```

The app starts a long-running process which waits until 6:15pm then gets the latest numbers and posts them to the channel you specified:

```
Latest UK numbers (daily):
- 23,511 cases (27/Jul)
- 945 admitted (22/Jul)
- 131 deaths (27/Jul)
- 810,459 tests (26/Jul)
- 236,261 vaccines (26/Jul)
#miseryBot
```

## Development

```sh
cp .env .env.local
# Put your Slack token etc. in .env.local
bundle install
ruby app.rb
```

### Testing

A nice PR for this project would be to write some tests using [minitest](https://github.com/seattlerb/minitest).
