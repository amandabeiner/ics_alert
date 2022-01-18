# frozen_string_literal: true

require './calendar_api'
require './calendar'

# Retrieves the .ics file and checks whether it contains an event ending
# tomorrow
class ReservationScanner
  def self.event_ending_tomorrow?
    response = CalendarApi.fetch_calendar_feed
    feed = response.body
    calendar = Calendar.new(feed: feed)
    puts calendar.event_ending_tomorrow?
  end
end
