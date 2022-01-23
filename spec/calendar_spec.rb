# frozen_string_literal: true

require './lib/calendar'

RSpec.describe Calendar do
  describe '#event_ending_tomorrow?' do
    feed = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nCALSCALE:GREGORIAN\r\n"\
            "BEGIN:VEVENT\r\nUID:123\r\nDTSTAMP:20220118T022142Z\r\n"\
            "DTSTART;VALUE=DATE:20200823\r\nDTEND;VALUE=DATE:20200214\r\n"\
            "SUMMARY:Reserved - Sharon\r\nEND:VEVENT"
    it 'returns true when the calendar contains an event that ends the next day' do
      Timecop.freeze(Date.new(2020, 2, 13)) do
        calendar = Calendar.new(feed: feed)
        expect(calendar.event_ending_tomorrow?).to eq(true)
      end
    end

    it 'returns false when the calendar does not contain an event that ends the next day' do
      Timecop.freeze(Date.new(2020, 2, 12)) do
        calendar = Calendar.new(feed: feed)
        expect(calendar.event_ending_tomorrow?).to eq(false)
      end
    end
  end
end
