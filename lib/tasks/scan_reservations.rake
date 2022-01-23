# frozen_string_literal: true

require_relative '../reservation_scanner'
require 'dotenv/tasks'

desc 'search reservations'
task :scan_reservations, :dotenv do
  ReservationScanner.alert_for_upcoming_reservation
end
