# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :tanka
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :posts, :tanka, unique: true
  end
end
