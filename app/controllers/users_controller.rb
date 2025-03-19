# frozen_string_literal: true

# users controller
class UsersController < ApplicationController
  def index
    authorize User

    @users = User.left_joins(:articles)
                 .select('users.*, COUNT(articles.id) AS public_articles_count')
                 .where(articles: { status: 'public' })
                 .group('users.id')
                 .order('public_articles_count DESC')
                 .limit(10)
  end

  def show
    authorize User

    @user = User.find_by(id: params[:id])

    return unless @user

    @articles = @user.articles
    @public_articles = @articles.where(status: 'public')
  end
end
