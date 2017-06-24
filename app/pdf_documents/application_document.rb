class ApplicationDocument < Prawn::Document

  def initialize(options = {}, &block)
    super(options, &block)
  end

  def display_price(amount)
    ActionController::Base.helpers.number_to_currency(amount)
  end

  def t(*attrs)
    I18n.t *attrs
  end
end
