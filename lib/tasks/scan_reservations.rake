# frozen_string_literal: true

require './reservation_feed'
require 'dotenv/tasks'

desc 'search reservations'
task :scan_reservations, :dotenv do
  ReservationFeed.events
end
