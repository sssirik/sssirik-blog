# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :with_admin_role do
      after(:create) do |user|
        create(:role, name: 'admin').users << user
      end
    end

    trait :with_editor_role do
      after(:create) do |user|
        create(:role, name: 'editor').users << user
      end
    end
  end
end
