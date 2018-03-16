class AddCreatorIdAndUpdaterIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :creator_id, :integer
    add_index :users, :creator_id
    add_column :users, :updater_id, :integer
    add_index :users, :updater_id
  end
end
