# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlePolicy, type: :policy do
  subject { described_class.new(user, article) }

  let(:article) { create(:article) }

  context 'when user is not signed in' do
    let(:user) { nil }

    it { should permit_action(:index) }
    it { should permit_action(:show) if article.public? }
    it { should forbid_action(:show) if article.private? || article.archived? }
    it { should forbid_action(:new) }
    it { should forbid_action(:create) }
    it { should forbid_action(:edit) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'when user is signed in but not the owner' do
    let(:user) { create(:user) }

    it { should permit_action(:index) }
    it { should permit_action(:show) if article.public? }
    it { should forbid_action(:show) if article.private? || article.archived? }
    it { should permit_action(:new) }
    it { should permit_action(:create) }
    it { should forbid_action(:edit) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'when user is the owner of the article' do
    let(:user) { article.user }

    it { should permit_action(:index) }
    it { should permit_action(:show) }
    it { should permit_action(:new) }
    it { should permit_action(:create) }
    it { should permit_action(:edit) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  context 'when user has admin role' do
    let(:user) { create(:user, :with_admin_role) }

    it { should permit_action(:index) }
    it { should permit_action(:show) }
    it { should permit_action(:new) }
    it { should permit_action(:create) }
    it { should permit_action(:edit) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  describe 'Scope' do
    let(:user) { create(:user) }
    let(:public_article) { create(:article, status: 'public') }
    let(:private_article) { create(:article, status: 'private', user: user) }
    let(:archived_article) { create(:article, status: 'archived') }
    let(:other_user_private_article) { create(:article, status: 'private') }

    subject { ArticlePolicy::Scope.new(user, Article.all).resolve }

    context 'for a regular user' do
      it 'includes public articles' do
        expect(subject).to include(public_article)
      end

      it 'includes private articles owned by the user' do
        expect(subject).to include(private_article)
      end

      it 'does not include archived articles' do
        expect(subject).not_to include(archived_article)
      end

      it 'does not include private articles owned by other users' do
        expect(subject).not_to include(other_user_private_article)
      end
    end

    context 'for an admin user' do
      let(:user) { create(:user, :with_admin_role) }

      it 'includes all articles' do
        expect(subject).to include(public_article, private_article, archived_article, other_user_private_article)
      end
    end
  end
end
