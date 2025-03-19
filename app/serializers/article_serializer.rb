# frozen_string_literal: true

# serializer for article api
class ArticleSerializer
  include JSONAPI::Serializer

  attributes :title, :body, :status

  attribute :likes do |article|
    article.likes.count
  end

  attribute :author do |article|
    { id: article.user.id, email: article.user.email }
  end

  attribute :comments do |article|
    article.comments.map do |comment|
      {
        id: comment.id,
        body: comment.body,
        likes: comment.likes.count,
        user: {
          id: comment.user.id,
          email: comment.user.email
        }
      }
    end
  end
end
