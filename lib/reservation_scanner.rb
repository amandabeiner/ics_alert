# frozen_string_literal: true

require_relative './calendar_api'
require_relative './calendar'

# Retrieves the .ics file and checks whether it contains an event ending
# tomorrow
class ReservationScanner
  def self.event_ending_tomorrow?
    response = CalendarApi.fetch_calendar_feed
    calendar = Calendar.new(feed: response.body)
    puts calendar.event_ending_tomorrow?
  end
end
