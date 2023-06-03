# frozen_string_literal: true

require './lib/calendar_api'

RSpec.describe CalendarApi do
  describe '#fetch_calendar_feed' do
    calendar_url = 'https://example.ics'
    calendar_key = 'CALENDAR_ICS_1'
    before do
      ENV["#{calendar_key}_URL"] = calendar_url
      ENV["#{calendar_key}_URL"] = calendar_url
    end

    it 'uses the calendar uri from the ENV' do
      stub_request(:get, calendar_url)

      CalendarApi.fetch_feed_for(calendar_key)

      expect(WebMock).to have_requested(:get, calendar_url)
    end
  end
end
