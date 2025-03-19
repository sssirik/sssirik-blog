# frozen_string_literal: true

# db migration for comment model
class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.text :body
      t.references :article, null: false, foreign_key: true
      t.string :status, default: 'public'

      t.timestamps
    end
  end
end
