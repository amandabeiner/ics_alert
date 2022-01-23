# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'dotenv/load'

# Fetches the .ics feed of reservations
class CalendarApi
  def self.fetch_calendar_feed
    Net::HTTP.get_response(calendar_uri)
  rescue StandardError => e
    puts e.message
  end

  def self.calendar_uri
    URI.parse ENV['CALENDAR_ICS_URL']
  end
end
