class AddStatusToAttendees < ActiveRecord::Migration[5.0]
  def change
    remove_column :attendees, :status, :string
    add_column :attendees, :status, :integer, default: 0
  end
end
