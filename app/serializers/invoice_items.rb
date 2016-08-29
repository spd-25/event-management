class InvoiceItems < JsonArraySerializer

  array_of InvoiceItem

  def sum
    map(&:price).sum
  end
end
