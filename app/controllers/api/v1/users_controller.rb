# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController

  def follow
    service = UserFollowing.new({following_user_id: params[:following_user_id],
                                           current_user: current_user }).follow
    service_response(service)
  end

  def unfollow
    service = UserFollowing.new({ following_user_id: params[:following_user_id],
                                        current_user: current_user }).unfollow
    service_response(service)
  end

end
