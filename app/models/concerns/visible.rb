# frozen_string_literal: true

# visibility of articles or commend
module Visible
  extend ActiveSupport::Concern

  VALID_STATUSES = %w[public private archived].freeze

  included do
    validates :status, inclusion: { in: VALID_STATUSES }
  end

  class_methods do
    def public_count
      where(status: 'public').count
    end
  end

  def archived?
    status == 'archived'
  end

  def private?
    status == 'private'
  end

  def public?
    status == 'public'
  end
end
