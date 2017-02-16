class CreateUsergroupsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :usergroups do |t|
      t.belongs_to :user, index: true
      t.belongs_to :group, index: true
      t.timestamps
    end

  end
end
