# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :with_admin_role) }
  let(:other_user) { create(:user) }

  describe '#allow_all_articles?' do
    context 'when user is the record owner' do
      it 'returns true' do
        expect(described_class.new(user, user).allow_all_articles?).to be true
      end
    end

    context 'when user is an admin' do
      it 'returns true' do
        expect(described_class.new(admin, user).allow_all_articles?).to be true
      end
    end

    context 'when user is neither admin nor the record owner' do
      it 'returns false' do
        expect(described_class.new(other_user, user).allow_all_articles?).to be false
      end
    end
  end
end
