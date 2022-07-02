# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'dotenv/load'
require 'httparty'
# Fetches the .ics feed of reservations
class CalendarApi
  def self.fetch_feed_for(calendar_id)
    uri = uri_for(calendar_id)
    HTTParty.get(uri, follow_redirects: true)
  rescue StandardError => e
    puts e.message
  end

  def self.uri_for(calendar_id)
    URI.parse ENV["#{calendar_id}_URL"]
  end
end
