# frozen_string_literal: true

require 'slack-ruby-client'

class SlackClient
  def initialize(token, channel, thread_ts = nil)
    @client = Slack::Web::Client.new token: token
    @channel = channel
    @thread_ts = thread_ts
  end

  def post_message(message)
    kwargs = {
      channel: @channel, text: message, as_user: true, unfurl_links: false,
      unfurl_media: false
    }

    if @thread_ts
      kwargs[:reply_broadcast] = true
      kwargs[:thread_ts] = @thread_ts
    end

    @client.chat_postMessage(**kwargs)
  end
end
