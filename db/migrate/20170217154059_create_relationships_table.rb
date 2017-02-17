class CreateRelationshipsTable < ActiveRecord::Migration[5.0]
  def change

    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
    end

  end
end
