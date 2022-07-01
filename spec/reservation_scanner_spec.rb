# frozen_string_literal: true

require './lib/reservation_scanner'

DATE_TIME_FORMAT = '%Y%m%dT%H%M%SZ'
DATE_FORMAT = '%Y%m%d'
RSpec.describe ReservationScanner do
  describe '#alert_for_upcoming_reservation' do
    calendar_url = 'https://example.ics'
    def feed_for_end_date(end_date)
      is_datetime = end_date.is_a?(DateTime)
      dtend = is_datetime ? end_date.strftime(DATE_TIME_FORMAT) : end_date.strftime(DATE_FORMAT)
      "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nCALSCALE:GREGORIAN\r\n"\
       "BEGIN:VEVENT\r\nUID:123\r\nDTSTAMP:20220118T022142Z\r\n"\
       "DTSTART;VALUE=DATE:20200823\r\nDTEND#{!is_datetime ? ';VALUE=DATE' : ''}:#{dtend}\r\n"\
       "SUMMARY:Reserved - Sharon\r\nEND:VEVENT"
    end

    before do
      ENV['CALENDAR_ICS_URL'] = calendar_url
    end

    it 'sends a text message if there is a calendar event ending the next day' do
      end_date = DateTime.civil(2020, 2, 14, 8, 0, 0)
      Timecop.freeze(Date.new(2020, 2, 13)) do
        stub_request(:get, calendar_url).to_return({ 'body' => feed_for_end_date(end_date) })

        ReservationScanner.alert_for_upcoming_reservation

        messages = Twilio::REST::Client.messages
        expect(messages).not_to be_empty
      end
    end

    it 'sends a message if there is a calendar event ending at midnight in two days' do
      end_date = Date.civil(2020, 2, 15)
      Timecop.freeze(Date.new(2020, 2, 13)) do
        stub_request(:get, calendar_url).to_return({ 'body' => feed_for_end_date(end_date) })

        ReservationScanner.alert_for_upcoming_reservation

        messages = Twilio::REST::Client.messages
        expect(messages).not_to be_empty
      end
    end

    it 'does not send a message if there is a calendar event ending at a time other than midnight in two days' do
      end_date = DateTime.civil(2020, 2, 15)
      Timecop.freeze(Date.new(2020, 2, 13)) do
        stub_request(:get, calendar_url).to_return({ 'body' => feed_for_end_date(end_date) })

        ReservationScanner.alert_for_upcoming_reservation

        messages = Twilio::REST::Client.messages
        expect(messages).to be_empty
      end
    end
  end
end
