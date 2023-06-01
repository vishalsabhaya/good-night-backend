# frozen_string_literal: true

# It's a service class that manages sleep tracking of a user
class SleepTrack
  attr_reader :options

  def initialize(options)
    @current_user = options[:current_user]
    @response = Response.new
  end

  ##
  # sleep records of a user’s All following users’ sleep records. from the previous week, which are sorted based on the duration of All friends sleep length.
  def index
    @response.data = @current_user.following_users.last_week_sleep_trackings.as_json
    return @response
  end

  ##
  # save clockin time when you are going to sleep
  # do not allow to clock in if do not clockout previous record
  def clock_in
    last_sleep_record = @current_user.sleep_trackings.where(clock_out:nil)
    if last_sleep_record.present?
      @response.errors << I18n.t("error.E0006")
      @response.is_success = false
      return @response
    end

    @current_user.sleep_trackings.create(clock_in: Time.zone.now)
    saved_records = @current_user.sleep_trackings.order(:created_at)
    @response.message = I18n.t("info.I0003")
    @response.data = saved_records
    return @response
  end

  ##
  # save checkout time when you are wakeup
  # do not allow to clock out. if clock in not done.
  def clock_out
    last_sleep_record = @current_user.sleep_trackings.find_by(clock_out:nil)
    if last_sleep_record.present? && last_sleep_record.clock_out.nil?
      current_time = Time.zone.now
      last_sleep_record.update!(clock_out: current_time, sleep_duration: (current_time - last_sleep_record.clock_in))
      @response.message = I18n.t("info.I0004")
    else
      @response.errors << I18n.t("error.E0007")
      @response.is_success = false
    end
    return @response
  end

end
