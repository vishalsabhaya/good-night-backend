FactoryBot.define do
  factory :following do
    association :user, factory: :user
    association :following_user, factory: :user
  end
end
