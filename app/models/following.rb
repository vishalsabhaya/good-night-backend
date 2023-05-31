# frozen_string_literal: true

class Following < ApplicationRecord
  belongs_to :user # user which have follower
  belongs_to :following_user, class_name: :User #user following
end
