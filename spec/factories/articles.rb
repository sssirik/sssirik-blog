# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    status { 'public' }
    user

    trait :private do
      status { 'private' }
    end

    trait :archived do
      status { 'archived' }
    end
  end
end
