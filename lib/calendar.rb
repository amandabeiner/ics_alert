# frozen_string_literal: true

require 'tzinfo'
require 'icalendar'
require 'icalendar/tzinfo'

# Parses the .ics feed into an Icalendar object
class Calendar
  DEFAULT_TIME_ZONE = 'America/New_York'
  def initialize(feed:)
    @feed = feed
    @calendars = parse_ics_feed
  end

  def event_ending_tomorrow?
    return false unless calendar

    event_ending_next_day?
  end

  private

  def calendar
    @calendars.first
  end

  def parse_ics_feed
    Icalendar::Calendar.parse(@feed)
  end

  def event_ending_next_day?
    events.any? { |event| ends_next_day?(event) }
  end

  # Private: Is there an event ending the next day?
  #
  # All-day events are are Date objects without a Time, which end at midnight.
  # These events technically end in two days
  # We want to count events ending in two days only if they end at midnight
  #
  # Returns Boolean
  def ends_next_day?(event)
    event.dtend.to_date == if event.dtend.is_a?(Icalendar::Values::Date)
                             day_after_tomorrow.to_date
                           else
                             tomorrow.to_date
                           end
  end

  def events
    calendar.events
  end

  def timezone
    zone_id = calendar.custom_properties['x_wr_timezone']&.first
    return DEFAULT_TIME_ZONE unless zone_id

    TZInfo::Timezone.get(zone_id.to_s)
  end

  def tomorrow
    Time.now.in_time_zone(timezone) + 1.day
  end

  def day_after_tomorrow
    (tomorrow + 1.day).beginning_of_day
  end
end
