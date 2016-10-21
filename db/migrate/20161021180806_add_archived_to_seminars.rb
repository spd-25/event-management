class AddArchivedToSeminars < ActiveRecord::Migration[5.0]
  def change
    # add_column :seminars, :archived, :boolean, default: false
    # add_index :seminars, :archived
    change_table :seminars do |t|
      t.boolean :archived, default: false, index: true
    end
  end
end
