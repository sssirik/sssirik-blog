# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validations' do
    subject { build(:article) }

    it { should validate_presence_of(:title) }
    it { should allow_value('Valid title').for(:title) }
    it { should_not allow_value('').for(:title) }
    it { should_not allow_value(nil).for(:title) }

    it { should validate_presence_of(:body) }
    it { should allow_value('Valid body').for(:body) }
    it { should_not allow_value('').for(:body) }
    it { should_not allow_value(nil).for(:body) }

    it { should validate_length_of(:body).is_at_least(10) }

    it 'validates status inclusion in VALID_STATUSES' do
      expect(subject).to allow_value(*Visible::VALID_STATUSES).for(:status)
      expect(subject).not_to allow_value('invalid_status').for(:status)
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'module inclusion' do
    it 'includes the Visible module' do
      expect(described_class.ancestors).to include(Visible)
    end
  end

  describe '#archived?' do
    let(:article) { create(:article, status: 'archived') }

    it 'returns true when status is archived' do
      expect(article.archived?).to be_truthy
    end
  end

  describe '#private?' do
    let(:article) { create(:article, status: 'private') }

    it 'returns true when status is private' do
      expect(article.private?).to be_truthy
    end
  end

  describe '#public?' do
    let(:article) { create(:article, status: 'public') }

    it 'returns true when status is public' do
      expect(article.public?).to be_truthy
    end
  end
end
