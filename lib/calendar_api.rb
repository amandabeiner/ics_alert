# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'dotenv/load'
require 'httparty'
require 'pry'
require_relative './twilio_api'
# Fetches the .ics feed of reservations
class CalendarApi
  def self.fetch_feed_for(calendar_id)
    uri = uri_for(calendar_id)
    response = HTTParty.get(uri, follow_redirects: true)
    unless response.ok?
      TwilioApi.send_support_text_message(calendar_id)

      raise "Error fetching calendar #{calendar_id}"
    end
    raise "Error fetching calendar #{calendar_id}" unless response.ok?

    response
  end

  def self.uri_for(calendar_id)
    URI.parse ENV["#{calendar_id}_URL"]
  end
end
