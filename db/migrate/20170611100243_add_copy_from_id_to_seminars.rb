class AddCopyFromIdToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :copy_from_id, :integer
  end
end
