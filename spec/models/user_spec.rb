# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:follower).with_foreign_key(:user_id) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
