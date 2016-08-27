class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.references :seminar
      t.boolean :company
      # t.jsonb :invoice_address, default: '{}'
      t.text :invoice_address
      t.jsonb :contact, default: '{}'
      t.string :company_name
      t.integer :places, default: 1
      t.jsonb :other, default: '{}'

      t.timestamps
    end

    add_foreign_key :bookings, :seminars, on_delete: :cascade
  end
end
