class ApplicationDocument < Prawn::Document
  # include ActionView::Helpers

  def initialize(options = {}, &block)
    super(options, &block)
  end

  def ldate(date, options = nil)
    return '' unless date.present?
    I18n.l date, options
  end

  def display_price(amount)
    ActionController::Base.helpers.number_to_currency(amount)
  end

  def t(*attrs)
    I18n.t *attrs
  end
end
