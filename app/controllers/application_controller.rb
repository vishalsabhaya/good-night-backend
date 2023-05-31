class ApplicationController < ActionController::API
  include ApiResponse

  def current_user
    @current_user ||= User.find(params[:user_id])
  end

end
