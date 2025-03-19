# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  let(:comment) { create(:comment) }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'when liking an article' do
      before { post :create, params: { article_id: article.id } }

      it 'creates a like for the article' do
        expect(user.likes.exists?(likeable: article)).to be true
      end

      it 'responses with 302 found' do
        expect(response).to have_http_status(:found)
      end
    end

    context 'when liking a comment' do
      before { post :create, params: { article_id: article.id, comment_id: comment.id } }

      it 'creates a like for the comment' do
        expect(user.likes.exists?(likeable: comment)).to be true
      end

      it 'responses with 302 found' do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:like) { create(:like, user: user, likeable: article) }

    before { delete :destroy, params: { article_id: article.id, id: like.id } }

    it 'destroys the like' do
      expect(user.likes.exists?(likeable: article)).to be false
    end

    it 'responses with 302 found' do
      expect(response).to have_http_status(:found)
    end
  end
end
