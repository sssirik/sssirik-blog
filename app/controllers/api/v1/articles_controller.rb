# frozen_string_literal: true

module Api
  module V1
    # api articles controller
    class ArticlesController < ApplicationController
      def index
        authorize Article

        @articles = policy_scope(Article)
        render json: ArticleSerializer.new(@articles).serializable_hash, status: :ok
      end

      def show
        authorize Article

        @article = policy_scope(Article).find(params[:id])
        render json: ArticleSerializer.new(@article).serializable_hash, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Article not found' }, status: :not_found
      end
    end
  end
end
