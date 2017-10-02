class AddCancelationReasonToAttendees < ActiveRecord::Migration[5.1]
  def change
    change_table :attendees do |t|
      t.text :cancellation_reason
      t.integer :canceled_by_id, index: true
    end
  end
end
