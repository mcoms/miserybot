# frozen_string_literal: true

require 'faraday'
require 'json'

require_relative 'record'

class WebClient
  def initialize(data_url)
    @data_url = data_url
    @connection = Faraday.new(request: { params_encoder: Faraday::FlatParamsEncoder }) do |f|
      f.response :follow_redirects
      f.response :json
      f.response :raise_error
    end
  end

  def fetch_records
    json = @connection.get(@data_url).body
    raise 'Could not find a body in the returned JSON' unless json.key?('body') && json['body'].is_a?(Array)

    json['body'].map { |r| Record.new r }
  end
end
