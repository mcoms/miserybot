# frozen_string_literal: true

require 'slack-ruby-client'

class SlackClient
  def initialize(token, channel)
    @client = Slack::Web::Client.new token: token
    @channel = channel
  end

  def post_message(message)
    @client.chat_postMessage(channel: @channel, text: message, as_user: true,
                             unfurl_links: false, unfurl_media: false)
  end
end
