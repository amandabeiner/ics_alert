# frozen_string_literal: true

class Calendar
  def initialize(feed:)
    @feed = feed
    @calendar = parse_ics_feed
  end

  def parse_ics_feed
    Icalendar::Calendar.parse(@feed)
  end

  def events
    @calendar.first.events
  end

  def event_ending_on?(date:)
    events.any? { |e| e.dtend == date }
  end
end
