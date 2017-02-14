class CreateGroupsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.belongs_to :user, index: true
      t.belongs_to :group, index: true
    end

  end
end
