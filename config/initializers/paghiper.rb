# frozen_string_literal: true

Paghiper.configure do |config|
  config.api_key = ENV['PAGHIPER_API_KEY']
  config.token = ENV['PAG_HIPER_TOKEN']
  config.http_debug = true
end
