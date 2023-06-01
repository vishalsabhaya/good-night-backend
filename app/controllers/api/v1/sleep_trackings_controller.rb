# frozen_string_literal: true

# It's a controller to manage sleep tracking related actions.
class Api::V1::SleepTrackingsController < ApplicationController

  ##
  # > sleep records of a user’s All following users’ sleep records. from the previous week, which are sorted based on the duration of All friends sleep length.
  def index
    service = SleepTrack.new({current_user: current_user }).index
    service_response(service)
  end

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
