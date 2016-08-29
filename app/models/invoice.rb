class Invoice < ApplicationRecord
  enum status: { created: 0, sent: 1, payed: 2 }

  belongs_to :booking

  serialize :items, InvoiceItems

  validates :number, :date, presence: true

end
