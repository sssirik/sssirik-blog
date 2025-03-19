# frozen_string_literal: true

# comment model
class Comment < ApplicationRecord
  include Visible

  belongs_to :user
  belongs_to :article

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :body, presence: true
end
