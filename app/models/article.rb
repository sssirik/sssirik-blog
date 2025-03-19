# frozen_string_literal: true

# article model
class Article < ApplicationRecord
  include Visible

  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
