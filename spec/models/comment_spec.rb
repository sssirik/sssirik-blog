# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    subject { build(:comment) }

    it { should validate_presence_of(:body) }
    it { should allow_value('Valid body').for(:body) }
    it { should_not allow_value('').for(:body) }
    it { should_not allow_value(nil).for(:body) }

    it 'validates status inclusion in VALID_STATUSES' do
      expect(subject).to allow_value(*Visible::VALID_STATUSES).for(:status)
      expect(subject).not_to allow_value('invalid_status').for(:status)
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:article) }
  end

  describe 'module inclusion' do
    it 'includes the Visible module' do
      expect(described_class.ancestors).to include(Visible)
    end
  end

  describe '#archived?' do
    let(:comment) { create(:comment, status: 'archived') }

    it 'returns true when status is archived' do
      expect(comment.archived?).to be_truthy
    end
  end

  describe '#private?' do
    let(:comment) { create(:comment, status: 'private') }

    it 'returns true when status is private' do
      expect(comment.private?).to be_truthy
    end
  end

  describe '#public?' do
    let(:comment) { create(:comment, status: 'public') }

    it 'returns true when status is public' do
      expect(comment.public?).to be_truthy
    end
  end
end
