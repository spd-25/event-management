class AddSeminarIdToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :invoices, :seminar, foreign_key: true
  end
end
