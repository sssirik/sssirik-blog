# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    subject { build(:like) }

    it { should validate_uniqueness_of(:user_id).scoped_to(%i[likeable_id likeable_type]) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end
end
