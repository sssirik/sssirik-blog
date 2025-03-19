# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let!(:user) { create(:user, :with_admin_role) }
  let!(:article) { create(:article, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'authorizes the action and returns a success response' do
      allow(Pundit).to receive(:authorize)
      get :index
      expect(response).to be_successful
      expect(controller.instance_variable_get(:@articles)).to match_array([article])
    end
  end

  describe 'GET #show' do
    it 'authorizes the action and returns a success response' do
      allow(Pundit).to receive(:authorize)
      get :show, params: { id: article.id }
      expect(response).to be_successful
      expect(controller.instance_variable_get(:@article)).to eq(article)
    end
  end

  describe 'GET #new' do
    it 'authorizes the action and returns a success response' do
      allow(Pundit).to receive(:authorize)
      get :new
      expect(response).to be_successful
      expect(controller.instance_variable_get(:@article)).to be_a_new(Article)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'authorizes the action and creates a new article' do
        allow(Pundit).to receive(:authorize)
        expect do
          post :create, params: { article: attributes_for(:article) }
        end.to change(Article, :count).by(1)

        expect(response).to redirect_to(Article.last)
      end
    end

    context 'with invalid parameters' do
      it 'authorizes the action and does not create a new article' do
        allow(Pundit).to receive(:authorize)
        expect do
          post :create, params: { article: { title: '', body: '' } }
        end.not_to change(Article, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(controller.instance_variable_get(:@article)).to be_a_new(Article)
      end
    end
  end

  describe 'GET #edit' do
    it 'authorizes the action and returns a success response' do
      allow(Pundit).to receive(:authorize)
      get :edit, params: { id: article.id }

      expect(response).to be_successful
      expect(controller.instance_variable_get(:@article)).to eq(article)
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      it 'authorizes the action and updates the article' do
        allow(Pundit).to receive(:authorize)
        put :update, params: { id: article.id, article: { title: 'Updated Title' } }
        article.reload

        expect(article.title).to eq('Updated Title')
        expect(response).to redirect_to(article)
      end
    end

    context 'with invalid parameters' do
      it 'authorizes the action and does not update the article' do
        allow(Pundit).to receive(:authorize)
        put :update, params: { id: article.id, article: { title: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(controller.instance_variable_get(:@article)).to eq(article)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'authorizes the action and destroys the article' do
      allow(Pundit).to receive(:authorize)
      expect do
        delete :destroy, params: { id: article.id }
      end.to change(Article, :count).by(-1)

      expect(response).to redirect_to(root_path)
    end
  end
end
