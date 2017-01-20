class AddCommentsToAttendees < ActiveRecord::Migration[5.0]
  def change
    add_column :attendees, :comments, :text
  end
end
