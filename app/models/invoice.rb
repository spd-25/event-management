class Invoice < ApplicationRecord
  enum status: { created: 0, sent: 1, payed: 2 }

  has_one :booking, inverse_of: :invoice

  serialize :items, InvoiceItems

  validates :number, :date, presence: true

  has_paper_trail

  def name
    number
  end

  def self.next_number
    invoice = order(number: :desc).first
    invoice ? invoice.number.next : "#{Date.current.year}00001"
  end

end
