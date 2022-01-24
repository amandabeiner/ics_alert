# frozen_string_literal: true

require 'tzinfo'
require 'icalendar'
require 'icalendar/tzinfo'

# Parses the .ics feed into an Icalendar object
class Calendar
  def initialize(feed:)
    @feed = feed
    @calendar = parse_ics_feed
  end

  def event_ending_tomorrow?
    event_ending_on?(time: tomorrow)
  end

  private

  def parse_ics_feed
    Icalendar::Calendar.parse(@feed)
  end

  def events
    @calendar.first.events
  end

  def event_ending_on?(time:)
    events.any? { |e| e.dtend.to_date == time.to_date }
  end

  def timezone
    zone_id = @calendar.first.custom_properties['x_wr_timezone'][0] || 'America/New_York'
    TZInfo::Timezone.get(zone_id.to_s)
  end

  def tomorrow
    Time.now.in_time_zone(timezone) + 1.day
  end
end
