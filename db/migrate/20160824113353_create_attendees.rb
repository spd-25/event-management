class CreateAttendees < ActiveRecord::Migration[5.0]
  def change
    create_table :attendees do |t|
      t.references :seminar, foreign_key: true
      t.references :booking, index: true
      t.string :first_name
      t.string :last_name
      t.string :status
      t.jsonb :address, default: '{}'
      t.jsonb :contact, default: '{}'
      t.string :profession
      t.string :gender
      t.integer :age
      t.jsonb :other, default: '{}'

      t.timestamps
    end
    add_foreign_key :attendees, :bookings, on_delete: :cascade
  end
end
