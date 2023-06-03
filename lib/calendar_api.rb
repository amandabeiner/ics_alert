# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'dotenv/load'
require 'httparty'
require 'pry'
require_relative './twilio_api'
# Fetches the .ics feed of reservations
class CalendarApi
  RETRY_LIMIT = 5

  def self.fetch_feed_for(calendar_id)
    new(calendar_id).fetch_with_retry
  end

  def initialize(calendar_id)
    @calendar_id = calendar_id
    @retries = 0
  end

  def fetch_with_retry
    response = HTTParty.get(uri, follow_redirects: true)

    report_and_retry(response) unless response.ok?

    response
  end

  private

  def report_and_retry(response)
    puts "Failed to fetch #{calendar_id}: #{response.body}"
    @retries += 1
    puts "Retrying fetch, attempt: #{retries}"
    retries >= RETRY_LIMIT ? TwilioApi.send_support_text_message(calendar_id) : fetch_with_retry
  end

  def uri
    URI.parse ENV["#{calendar_id}_URL"]
  end

  attr_reader :retries, :calendar_id
end
