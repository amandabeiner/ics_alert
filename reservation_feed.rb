# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'icalendar'
require 'pry'
require 'dotenv/load'

# Class to fetch the .ics feed of reservations
class ReservationFeed
  def self.events
    response = Net::HTTP.get_response(calendar_uri)
    calendar = parse_response(response)
    puts events_for(calendar)
  end

  def self.parse_response(res)
    Icalendar::Calendar.parse(res.body)
  end

  def self.events_for(calendar)
    calendar.first.events
  end

  def self.calendar_uri
    URI.parse ENV['CALENDAR_ICS_URL']
  end
end
