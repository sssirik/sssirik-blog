# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    status { 'public' }
    user
    article

    trait :private do
      status { 'private' }
    end

    trait :archived do
      status { 'archived' }
    end
  end
end
