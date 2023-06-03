# frozen_string_literal: true

require './lib/calendar_api'

RSpec.describe CalendarApi do
  describe '#fetch_feed_for' do
    calendar_url = 'https://example.ics'
    calendar_key = 'CALENDAR_ICS_1'
    success_response = { status: 200 }
    error_response = { status: 404, body: 'not found' }
    before do
      allow_any_instance_of(CalendarApi).to receive(:sleep)
      ENV["#{calendar_key}_URL"] = calendar_url
      ENV["#{calendar_key}_URL"] = calendar_url
    end

    it 'uses the calendar uri from the ENV' do
      stub_request(:get, calendar_url).to_return(success_response)

      CalendarApi.fetch_feed_for(calendar_key)

      expect(a_request(:get, calendar_url)).to have_been_made.once
    end

    it 'retries fetch on error' do
      stub_request(:get, calendar_url).to_return(error_response, success_response)

      CalendarApi.fetch_feed_for(calendar_key)

      expect(a_request(:get, calendar_url)).to have_been_made.times(2)
    end

    it 'only retries 5 times' do
      stub_request(:get, calendar_url).to_return(error_response)

      CalendarApi.fetch_feed_for(calendar_key)

      expect(a_request(:get, calendar_url)).to have_been_made.times(5)
    end

    it 'queues a support text message after the 5th retry' do
      stub_request(:get, calendar_url).to_return(error_response)
      expect(TwilioApi).to receive(:send_support_text_message)

      CalendarApi.fetch_feed_for(calendar_key)
    end
  end
end
