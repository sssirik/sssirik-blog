# frozen_string_literal: true

# user model
class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable, :validatable

  has_many :comments, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
