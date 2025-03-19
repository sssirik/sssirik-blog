# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { 'admin' }

    trait :editor do
      name { 'editor' }
    end
  end
end
