# frozen_string_literal: true

require 'bundler'
require 'webmock/rspec'
require_relative './fake_twilio'
Bundler.require(:default, :test)
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_const('Twilio::REST::Client', FakeTwilio)
    FakeTwilio.messages = []
  end
end
