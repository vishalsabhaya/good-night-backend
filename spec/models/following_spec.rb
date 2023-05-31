# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Following, type: :model do
  describe 'associations' do
    it { should belong_to(:user).class_name('User') }
    it { should belong_to(:following_user).class_name('User') }
  end
end
