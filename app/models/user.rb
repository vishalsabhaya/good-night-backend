# frozen_string_literal: true
class User < ApplicationRecord

  has_many :follower, foreign_key: :user_id, class_name: :Following
  has_many :following_users, through: :follower
  has_many :sleep_trackings

  #name must be present
  validates :name, presence: true

end
