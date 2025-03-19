# frozen_string_literal: true

# comments controller
class CommentsController < ApplicationController
  def create
    authorize Comment

    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to article_path(@article)
    else
      redirect_to article_path(@article), alert: 'Failed to create comment.'
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    authorize @comment

    @comment.destroy
    redirect_to article_path(@article), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :status)
  end
end
