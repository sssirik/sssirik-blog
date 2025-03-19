# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikePolicy, type: :policy do
  subject { described_class.new(user, like) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:like) { create(:like, user: user) }

  context 'when the user is logged in' do
    it { is_expected.to permit_action(:create) }

    context 'when the user owns the like' do
      it { is_expected.to permit_action(:destroy) }
    end

    context 'when the user does not own the like' do
      let(:like) { create(:like, user: other_user) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
