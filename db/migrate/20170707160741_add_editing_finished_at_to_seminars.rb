class AddEditingFinishedAtToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :editing_finished_at, :datetime
  end
end
