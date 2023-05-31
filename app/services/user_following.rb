# frozen_string_literal: true

# It's a service class that manages the user's following and un-following actions
class UserFollowing
  attr_reader :options

  def initialize(options = {})
    @following_user_id = options[:following_user_id]
    @current_user = options[:current_user]
    @response = Response.new
  end

  #follow user if not following already
  def follow
    following_user = validate_user
    if following_user.nil?
      return @response
    end

    if @current_user.id == following_user.id
      @response.errors << I18n.t("error.E0005")
      @response.is_success = false
      return @response
    end

    following = @current_user.follower.find_by(following_user_id: following_user.id)
    if following.present?
      @response.errors << I18n.t("error.E0003",p0: following_user.name)
      @response.is_success = false
    else
      @current_user.follower.create(following_user_id:following_user.id)
      @response.message = I18n.t("info.I0001",p0: following_user.name)
    end
    return @response
  end

  # unfollow user if it's already follow
  def unfollow
    following_user = validate_user
    if following_user.nil?
      return @response
    end
    following = @current_user.follower.find_by(following_user_id: following_user.id)
    if following
      following.destroy
      @response.message = I18n.t("info.I0002",p0: following_user.name)
    else
      @response.is_success = false
      @response.errors << I18n.t("error.E0004",p0: following_user.name)
    end
    return @response
  end

  private

  # check user is registed with us or not
  def validate_user
    following_user = User.find_by(id: @following_user_id)
    if following_user.nil?
      @response.errors << I18n.t("error.E0002")
      @response.is_success = false
    end
    following_user
  end

end
