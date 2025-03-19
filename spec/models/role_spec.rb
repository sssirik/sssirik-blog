# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:users) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
  end

  describe 'scopify methods' do
    let(:user) { create(:user) }
    let(:role) { create(:role, name: 'admin') }

    before do
      user.add_role(:admin)
    end

    it 'provides scopify methods on associated models' do
      expect(User.with_role(:admin)).to include(user)
    end
  end
end
