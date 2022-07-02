# frozen_string_literal: true

require './lib/reservation_scanner'

DATE_TIME_FORMAT = '%Y%m%dT%H%M%SZ'
DATE_FORMAT = '%Y%m%d'
RSpec.describe ReservationScanner do
  describe '#alert_for_upcoming_reservation' do
    calendar_url = 'https://example.ics'
    def feed_for_end_date(end_date)
      "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nCALSCALE:GREGORIAN\r\n"\
      "BEGIN:VEVENT\r\nUID:123\r\nDTSTAMP:20220118T022142Z\r\n"\
      "DTSTART;VALUE=DATE:20200823\r\nDTEND;VALUE=DATE:#{end_date}\r\n"\
      "SUMMARY:Reserved - Sharon\r\nEND:VEVENT"
    end

    before do
      ENV['CALENDAR_ICS_1_URL'] = calendar_url
      ENV['CALENDAR_ICS_2_URL'] = calendar_url
    end

    it 'sends a text message if there is a calendar event ending the next day' do
      Timecop.freeze(Date.new(2020, 2, 13)) do
        stub_request(:get, calendar_url).to_return({ 'body' => feed_for_end_date('20200214') })

        ReservationScanner.alert_for_upcoming_reservation

        messages = Twilio::REST::Client.messages
        expect(messages).not_to be_empty
      end
    end

    it 'does not send a text message if there is not a calendar event ending the next day' do
      Timecop.freeze(Date.new(2020, 2, 13)) do
        stub_request(:get, calendar_url).to_return({ 'body' => feed_for_end_date('20200215') })

        ReservationScanner.alert_for_upcoming_reservation

        messages = Twilio::REST::Client.messages
        expect(messages).to be_empty
      end
    end
  end
end
