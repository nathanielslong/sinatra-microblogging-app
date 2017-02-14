class CreateUsergroupsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :usergroups do |t|
      t.string :name
    end

  end
end
