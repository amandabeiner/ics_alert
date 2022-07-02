# frozen_string_literal: true

require 'twilio-ruby'

# Public: communicate with the Twilio API
class TwilioApi
  def self.send_text_messages_for(calendar_id)
    recipient_numbers_for(calendar_id).each do |number|
      new.send_text_message_for(calendar_id, number)
    end
  end

  def self.recipient_numbers_for(calendar_id)
    ENV["#{calendar_id}_TO_PHONE_NUMBER"].split(',')
  end

  def send_text_message_for(calendar_id, number)
    twilio_client.messages.create(
      from: ENV["#{calendar_id}_FROM_PHONE_NUMBER"],
      to: number,
      body: ENV["#{calendar_id}_ALERT_BODY"]
    )
    puts "queued text message for #{ENV["#{calendar_id}_NAME"]} to #{number}"
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
