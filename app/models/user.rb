# frozen_string_literal: true
class User < ApplicationRecord

  #name must be present
  validates :name, presence: true

end
