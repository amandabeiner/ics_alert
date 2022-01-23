# frozen_string_literal: true

require 'icalendar'
require 'pry'

# Parses the .ics feed into an Icalendar object
class Calendar
  def initialize(feed:)
    @feed = feed
    @calendar = parse_ics_feed
  end

  def event_ending_tomorrow?
    event_ending_on?(date: tomorrow)
  end

  private

  def parse_ics_feed
    Icalendar::Calendar.parse(@feed)
  end

  def events
    @calendar.first.events
  end

  def event_ending_on?(date:)
    events.any? { |e| e.dtend == date }
  end

  def tomorrow
    Date.today + 1
  end
end
