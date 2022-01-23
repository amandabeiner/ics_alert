# frozen_string_literal: true

require_relative '../reservation_scanner'
require 'dotenv/tasks'

desc 'search reservations'
task :scan_reservations, :dotenv do
  ReservationScanner.event_ending_tomorrow?
end
