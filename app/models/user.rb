# frozen_string_literal: true
class User < ApplicationRecord

  has_many :follower, foreign_key: :user_id, class_name: :Following
  #name must be present
  validates :name, presence: true

end
