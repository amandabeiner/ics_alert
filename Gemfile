# frozen_string_literal: true

ruby File.read('.ruby-version').strip
source 'https://rubygems.org'

gem 'activesupport'
gem 'dotenv'
gem 'http'
gem 'httparty'
gem 'icalendar'
gem 'rake'
gem 'sinatra'
gem 'twilio-ruby'

group :test do
  gem 'rspec'
  gem 'timecop'
  gem 'webmock'
end

group :test, :development do
  gem 'pry'
end
