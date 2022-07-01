# frozen_string_literal: true

require 'icalendar'
require './lib/calendar'

DATE_TIME_FORMAT = '%Y%m%dT%H%M%SZ'
DATE_FORMAT = '%Y%m%d'
RSpec.describe Calendar do
  describe '#event_ending_tomorrow?' do
    def build_feed(end_date:)
      is_datetime = end_date.is_a?(DateTime)
      dtend = is_datetime ? end_date.strftime(DATE_TIME_FORMAT) : end_date.strftime(DATE_FORMAT)
      "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nCALSCALE:GREGORIAN\r\n"\
       "BEGIN:VEVENT\r\nUID:123\r\nDTSTAMP:20220118T022142Z\r\n"\
       "DTSTART;VALUE=DATE:20200823\r\nDTEND#{!is_datetime ? ';VALUE=DATE' : ''}:#{dtend}\r\n"\
       "SUMMARY:Reserved - Sharon\r\nEND:VEVENT"
    end

    it 'returns true when the calendar contains an event that ends the next day' do
      ending_date = DateTime.civil(2022, 2, 14, 8, 0, 0)
      feed = build_feed(end_date: ending_date)
      Timecop.freeze(Date.new(2022, 2, 13)) do
        calendar = Calendar.new(feed: feed)
        expect(calendar.event_ending_tomorrow?).to eq(true)
      end
    end

    it 'returns true when the calendar contains an event that ends at midnight the day after tomorrow' do
      ending_date = Date.civil(2022, 2, 15)
      feed = build_feed(end_date: ending_date)
      Timecop.freeze(Date.new(2022, 2, 13)) do
        calendar = Calendar.new(feed: feed)
        expect(calendar.event_ending_tomorrow?).to eq(true)
      end
    end

    it 'returns false when the calendar does not contain an event that ends the next day' do
      ending_date = DateTime.civil(2022, 2, 18)
      feed = build_feed(end_date: ending_date)
      Timecop.freeze(Date.new(2022, 2, 13)) do
        calendar = Calendar.new(feed: feed)
        expect(calendar.event_ending_tomorrow?).to eq(false)
      end
    end

    it 'returns false when the calendar contains an event that ends at a time other than midnight the day
    after tomorrow' do
      ending_date = DateTime.civil(2022, 2, 15, 12, 12, 0)
      feed = build_feed(end_date: ending_date)
      Timecop.freeze(Date.new(2022, 2, 13)) do
        calendar = Calendar.new(feed: feed)
        expect(calendar.event_ending_tomorrow?).to eq(false)
      end
    end
  end
end
