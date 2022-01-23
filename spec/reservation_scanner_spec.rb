# frozen_string_literal: true

require './lib/reservation_scanner'

RSpec.describe ReservationScanner do
  describe '#alert_for_upcoming_reservation' do
    calendar_url = 'https://example.ics'
    feed = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nCALSCALE:GREGORIAN\r\n"\
            "BEGIN:VEVENT\r\nUID:123\r\nDTSTAMP:20220118T022142Z\r\n"\
            "DTSTART;VALUE=DATE:20200823\r\nDTEND;VALUE=DATE:20200214\r\n"\
            "SUMMARY:Reserved - Sharon\r\nEND:VEVENT"
    before do
      ENV['CALENDAR_ICS_URL'] = calendar_url
    end

    it 'sends a text message if there is a calendar event ending the next day' do
      Timecop.freeze(Date.new(2020, 2, 13)) do
        stub_request(:get, calendar_url).to_return({ 'body' => feed })

        ReservationScanner.alert_for_upcoming_reservation

        messages = Twilio::REST::Client.messages
        expect(messages).not_to be_empty
      end
    end

    it 'does not send a text message if there is not a recalendar event ending the next day' do
      Timecop.freeze(Date.new(2020, 2, 12)) do
        stub_request(:get, calendar_url).to_return({ 'body' => feed })

        ReservationScanner.alert_for_upcoming_reservation

        messages = Twilio::REST::Client.messages
        expect(messages).to be_empty
      end
    end
  end
end
