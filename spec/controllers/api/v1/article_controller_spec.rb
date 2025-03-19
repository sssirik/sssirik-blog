# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user: user) }
  let!(:comment) { create(:comment, article: article, user: user) }
  let!(:like) { create(:like, likeable: article, user: user) }

  describe 'GET #index' do
    before do
      create_list(:article, 3, user: user)
      get :index
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all articles' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].size).to eq(4)
    end

    it 'includes serialized attributes' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'][0]['attributes']).to include(
        'title',
        'body',
        'status',
        'likes',
        'author'
      )
    end
  end

  describe 'GET #show' do
    context 'when the article exists' do
      before do
        get :show, params: { id: article.id }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct article' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']['id']).to eq(article.id.to_s)
      end

      it 'includes comments and likes' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']['attributes']['comments'].first['id']).to eq(comment.id)
        expect(parsed_response['data']['attributes']['likes']).to eq(1)
      end
    end

    context 'when the article does not exist' do
      before do
        get :show, params: { id: 0 }
      end

      it 'returns a not_found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq('Article not found')
      end
    end
  end
end
