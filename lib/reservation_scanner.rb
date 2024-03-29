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
    calendar_ids.each do |cal|
      calendar_key = cal.match(/^CALENDAR_ICS_\d/)[0]
      response = CalendarApi.fetch_feed_for(calendar_key)
      calendar = Calendar.new(feed: response.body)
      if calendar.event_ending_tomorrow?
        send_text_alerts_for(calendar_key)
      else
        puts "No events ending tomorrow for #{calendar_key}"
      end
    end
  end

  def self.send_text_alerts_for(calendar)
    TwilioApi.send_text_messages_for(calendar)
  end

  def self.calendar_ids
    ENV.keys.filter { |k| k.match(/^CALENDAR_ICS_\d_NAME/) }
  end
end
