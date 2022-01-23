# frozen_string_literal: true

require_relative './calendar_api'
require_relative './calendar'
require_relative './twilio_api'

# Public: retrieves the .ics file for a calendar feed. Sends a text alert if the
#         feed contains an event ending the next day.
#
# returns nothing.
class ReservationScanner
  def self.alert_for_upcoming_reservation
    response = fetch_calendar_feed
    calendar = Calendar.new(feed: response.body)
    send_text_alert if calendar.event_ending_tomorrow?
  end

  def self.fetch_calendar_feed
    CalendarApi.fetch_calendar_feed
  end

  def self.send_text_alert
    TwilioApi.send_text_message
  end
end
