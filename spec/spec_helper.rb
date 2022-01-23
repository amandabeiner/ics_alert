require 'bundler'
require 'webmock/rspec'
Bundler.require(:default, :test)
WebMock.disable_net_connect!(allow_localhost: true)
