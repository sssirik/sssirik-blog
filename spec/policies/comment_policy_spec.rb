# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class.new(user, comment) }

  let(:comment) { create(:comment) }

  context 'when user is not signed in' do
    let(:user) { nil }

    it { should forbid_action(:create) }
    it { should forbid_action(:destroy) }
  end

  context 'when user is signed in but not the owner' do
    let(:user) { create(:user) }

    it { should permit_action(:create) }
    it { should forbid_action(:destroy) }
  end

  context 'when user is the owner of the comment' do
    let(:user) { comment.user }

    it { should permit_action(:create) }
    it { should permit_action(:destroy) }
  end

  context 'when user has admin role' do
    let(:user) { create(:user, :with_admin_role) }

    it { should permit_action(:create) }
    it { should permit_action(:destroy) }
  end

  describe 'Scope' do
    let(:user) { create(:user) }
    let(:public_comment) { create(:comment, status: 'public') }
    let(:private_comment) { create(:comment, status: 'private', user: user) }
    let(:archived_comment) { create(:comment, status: 'archived') }
    let(:other_user_private_comment) { create(:comment, status: 'private') }

    subject { CommentPolicy::Scope.new(user, Comment.all).resolve }

    context 'for a regular user' do
      it 'includes public comments' do
        expect(subject).to include(public_comment)
      end

      it 'includes private comments owned by the user' do
        expect(subject).to include(private_comment)
      end

      it 'does not include archived comments' do
        expect(subject).not_to include(archived_comment)
      end

      it 'does not include private comments owned by other users' do
        expect(subject).not_to include(other_user_private_comment)
      end
    end

    context 'for an admin user' do
      let(:user) { create(:user, :with_admin_role) }

      it 'includes all comments' do
        expect(subject).to include(public_comment, private_comment, archived_comment, other_user_private_comment)
      end
    end
  end
end
