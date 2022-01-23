# frozen_string_literal: true

require './lib/calendar_api'

RSpec.describe CalendarApi do
  describe '#fetch_calendar_feed' do
    calendar_url = 'https://example.ics'
    before do
      ENV['CALENDAR_ICS_URL'] = calendar_url
    end

    it 'uses the calendar uri from the ENV' do
      stub_request(:get, calendar_url)

      CalendarApi.fetch_calendar_feed

      WebMock.should have_requested(:get, calendar_url)
    end
  end
end
