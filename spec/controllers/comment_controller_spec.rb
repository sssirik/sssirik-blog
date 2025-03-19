# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user, :with_admin_role) }
  let!(:article) { create(:article, user: user) }
  let!(:comment) { create(:comment, article: article, user: user) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'authorizes the action and creates a new comment' do
        allow(Pundit).to receive(:authorize)
        expect do
          post :create, params: { article_id: article.id, comment: attributes_for(:comment) }
        end.to change(Comment, :count).by(1)

        expect(response).to redirect_to(article)
      end
    end

    context 'with invalid parameters' do
      it 'authorizes the action and does not create a new comment' do
        allow(Pundit).to receive(:authorize)
        expect do
          post :create, params: { article_id: article.id, comment: { body: '' } }
        end.not_to change(Comment, :count)

        expect(response).to redirect_to(article)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'authorizes the action and destroys the comment' do
      allow(Pundit).to receive(:authorize)
      expect do
        delete :destroy, params: { article_id: article.id, id: comment.id }
      end.to change(Comment, :count).by(-1)

      expect(response).to redirect_to(article)
    end

    context 'when unauthorized' do
      let(:another_user) { create(:user) }
      let(:unauthorized_comment) { create(:comment, article: article, user: another_user) }

      it 'does not destroy the comment if the user is not authorized' do
        allow(Pundit).to receive(:authorize).and_throw(:warden)

        expect do
          delete :destroy, params: { article_id: article.id, id: unauthorized_comment.id }
        end.not_to change(Comment, :count)

        expect(response).to have_http_status(:see_other)
      end
    end
  end
end
