class AddCompanyIdToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_reference :invoices, :company, index: true
  end
end
