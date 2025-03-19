# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user, :with_admin_role) }
  let!(:another_user) { create(:user) }
  let!(:public_articles) { create_list(:article, 3, user: another_user, status: 'public') }
  let!(:private_articles) { create_list(:article, 2, user: another_user, status: 'private') }
  let!(:articles) { another_user.articles.to_a }

  render_views

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'authorizes the action and returns a success response' do
      allow(Pundit).to receive(:authorize)
      get :index
      expect(response).to be_successful
      expect(controller.instance_variable_get(:@users).to_a).to eq([another_user])
      expect(controller.instance_variable_get(:@users).to_a[0].articles.where(status: 'public').count)
        .to eq(another_user.articles.where(status: 'public').count)
    end
  end

  describe 'GET #show' do
    context 'when user exists' do
      it 'authorizes the action and returns a success response' do
        allow(Pundit).to receive(:authorize)
        get :show, params: { id: another_user.id }
        expect(response).to be_successful
        expect(controller.instance_variable_get(:@user)).to eq(another_user)
        expect(controller.instance_variable_get(:@articles)).to match_array(articles)
        expect(controller.instance_variable_get(:@public_articles)).to match_array(public_articles)
      end
    end

    context 'when user does not exist' do
      it 'returns a success response and shows a message' do
        allow(Pundit).to receive(:authorize)
        get :show, params: { id: 0 }
        expect(response).to be_successful
        expect(response.body).to include('User not found.')
      end
    end
  end
end
