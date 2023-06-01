# frozen_string_literal: true
class User < ApplicationRecord

  has_many :follower, foreign_key: :user_id, class_name: :Following
  has_many :following_users, through: :follower
  has_many :sleep_trackings

  #name must be present
  validates :name, presence: true

  scope :last_week_sleep_trackings, lambda {
    joins(:sleep_trackings)
      .select('sleep_trackings.id', 'sleep_trackings.user_id', 'users.name', 'sleep_trackings.clock_in', 'sleep_trackings.clock_out', 'sleep_trackings.sleep_duration')
      .where(sleep_trackings: { created_at: 1.week.ago..Time.zone.now })
      .where.not(sleep_trackings: { clock_out: nil })
      .order(sleep_duration: :desc)
  }

end
