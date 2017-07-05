class AddLayoutFinishedAtToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :layout_finished_at, :datetime
  end
end
