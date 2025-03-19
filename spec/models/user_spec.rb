# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
  end

  describe 'associations' do
    it { should have_many(:comments) }
    it { should have_many(:articles) }
  end

  describe 'rolify integration' do
    let(:user) { create(:user) }

    it 'can add roles to a user' do
      user.add_role(:admin)
      expect(user.has_role?(:admin)).to be_truthy
    end

    it 'can remove roles from a user' do
      user.add_role(:editor)
      user.remove_role(:editor)
      expect(user.has_role?(:editor)).to be_falsey
    end
  end
end
