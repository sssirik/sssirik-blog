# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    user
    association :likeable, factory: :article

    trait :comment do
      association :likeable, factory: :comment
    end
  end
end
