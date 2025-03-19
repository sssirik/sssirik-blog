# frozen_string_literal: true

# likes controller
class LikesController < ApplicationController
  def create
    authorize Like

    current_user.likes.create(likeable: find_likeable) unless current_user.likes.exists?(likeable: find_likeable)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = current_user.likes&.find_by(likeable: find_likeable)

    authorize @like

    @like&.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def find_likeable
    { comment_id: Comment, article_id: Article }.each do |param_key, model_class|
      next unless params[param_key]

      return model_class.find_by(id: params[param_key])
    end
    nil
  end
end
