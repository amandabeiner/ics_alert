# frozen_string_literal: true

require 'twilio-ruby'

# Public: communicate with the Twilio API
class TwilioApi
  def self.send_text_message_for(calendar_id)
    new.send_text_message_for(calendar_id)
  end

  def send_text_message_for(calendar_id)
    twilio_client.messages.create(
      from: ENV["#{calendar_id}_FROM_PHONE_NUMBER"],
      to: ENV["#{calendar_id}_TO_PHONE_NUMBER"],
      body: ENV["#{calendar_id}_ALERT_BODY"]
    )
    puts "queued text message for #{ENV["#{calendar_id}_NAME"]}"
  end

  private

  def twilio_client
    Twilio::REST::Client.new(account_id, auth_token)
  end

  def account_id
    ENV['TWILIO_ACCOUNT_ID']
  end

  def auth_token
    ENV['TWILIO_AUTH_TOKEN']
  end
end
