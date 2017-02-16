class CreatePostsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.belongs_to :user, index: true
      t.string :body
      t.string :genre
      t.string :album
      t.string :artist
      t.timestamps
    end

  end
end
