class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :number, null: false
      t.date :date, null: false
      t.text :address
      t.text :pre_message
      t.text :post_message
      t.jsonb :items, default: '[]'
      t.integer :status, default: 0
      t.jsonb :others

      t.timestamps
    end
  end
end
