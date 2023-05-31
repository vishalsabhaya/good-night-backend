# frozen_string_literal: true

# It's a controller to manage sleep tracking related actions.
class Api::V1::SleepTrackingsController < ApplicationController

  ##
  # > Clock in the current user for sleep tracking.
  def clock_in
    service = SleepTrack.new({current_user: current_user }).clock_in
    service_response(service)
  end

  ##
  # > Clock out the current user for sleep tracking.
  def clock_out
    service = SleepTrack.new({current_user: current_user }).clock_out
    service_response(service)
  end

end
