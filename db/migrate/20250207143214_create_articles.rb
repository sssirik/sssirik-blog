# frozen_string_literal: true

# db migration for article model
class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text   :body
      t.string :status, default: 'public'

      t.timestamps
    end
  end
end
