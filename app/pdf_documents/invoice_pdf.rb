require 'prawn/measurement_extensions'

class InvoicePdf < ApplicationDocument

  attr_reader :invoice, :company

  def initialize(invoice)
    @debug         = false
    @margin_top    = 28.mm
    @margin_bottom = 28.mm
    @margin_side   = 20.mm
    super(page_size: 'A4', margin: [@margin_top, @margin_side, @margin_bottom])
    @invoice = invoice
    @booking = invoice.booking
    @seminar = @booking.seminar
    @company = OpenStruct.new name: 'Paritätische', phone: '0391/6293-313', fax: '', email: 'asdf'
    @header_text_options = { size: 30, style: :italic, align: :center }
    generate
  end

  def filename
    "#{Invoice.model_name.human}_#{invoice.number.sub('/', '-')}.pdf"
  end

  def generate
    stroke_bounds if @debug
    # write_header
    stroke_horizontal_rule if @debug
    write_address
    write_right_box
    write_heading
    move_down 20
    text invoice.pre_message
    write_seminar_box
    move_down 10
    write_positions
    move_down 20
    text invoice.post_message
    # write_footer
  end

  def write_header
    repeat(:all) do
      height = @margin_top / 2
      bounding_box [0, bounds.top + height], width: bounds.right, height: height do
        text company.name, @header_text_options
        # stroke_bounds if @debug
      end
    end
  end

  def write_address
    y = bounds.top - (50.mm - @margin_top)
    bounding_box([0, y], width: 90.mm, height: 45.mm) do
      # text company.full_address.join(' • '), size: 8, style: :italic
      stroke_horizontal_rule
      move_down 10
      text invoice.address
      stroke_bounds if @debug
    end
  end

  def write_right_box
    font_size 10 do
      y      = bounds.top - (50.mm - @margin_top)
      height = 50.mm
      width  = 70.mm
      box_options = { width: width, height: height }

      x = bounds.right - width
      bounding_box [x + 10, y], box_options do
        data = [
          [t(:phone), company.phone],
          [t(:fax), company.fax],
          [t(:email), company.email],
          [t(:invoice_date), ldate(invoice.date)],
        ]
        table data, { width: bounds.right, cell_style: { border_width: 0, padding: [1, 5] } }

      end
    end
  end

  def write_heading
    text "#{Invoice.model_name.human} Nr. #{invoice.number}", size: 20
  end

  def write_seminar_box
    font_size 11 do
      table seminar_data, seminar_table_options do |t|
        t.column(0).font_style = :bold
        t.cells.style { |c| c.align = :left }
      end
    end
  end

  def seminar_data
    [
      [Seminar.human_attribute_name(:title), @seminar.title],
      [Seminar.human_attribute_name(:number), @seminar.number],
      [Seminar.human_attribute_name(:date), @seminar.dates.map { |date| ldate date }.join('; ')],
      [Seminar.human_attribute_name(:time), @seminar.events.map(&:time).uniq.compact.join('; ')],
      [Teacher.model_name.human(count: @seminar.teachers.count), @seminar.teachers.map(&:name).join(', ')],
      [Seminar.human_attribute_name(:location), @seminar.location.name]
    ]
  end

  def seminar_table_options
    indent = 20
    {
      width:         bounds.right - indent,
      column_widths: { 0 => 120 },
      cell_style:    { borders: [:top, :bottom], border_width: 0, padding: [1, 5] },
      position:      indent
    }
  end

  def write_positions
    text 'Folgende Teilnehmer/innen sind in dieser Rechnung berücksichtigt:'
    move_down 10
    font_size 11 do
      table positions_array, positions_table_options do |t|
        t.row(-1).font_style = :bold
        t.cells.style { |c| c.align = :right if c.column == 1 }
      end
    end
    move_down 20
  end

  def positions_array
    # [%w(Teilnehmer Gebühr)] + invoice.items.map { |item| [item.attendee, display_price(item.price)] }
    invoice.items.map { |item| [item.attendee, display_price(item.price)] } +
        [['Gesamtgebühr', display_price(invoice.items.sum)]]
  end

  def positions_table_options
    {
      row_colors:    %w( FFFFFF EEEEEE),
      # header:        false,
      width:         3*bounds.right/4,
      column_widths: { 1 => 120 },
      cell_style:    { borders: [:top, :bottom], border_width: 0.2, border_lines: [:solid, :dashed], padding: [4, 5] }
    }
  end

  # def write_positions_sum
  #   font_size 11 do
  #     table sum_rows, positions_sum_options do |t|
  #       t.row(0).font_style = :bold
  #       t.cells.style { |c| c.align = :right }
  #     end
  #   end
  # end

  def sum_rows
    [['Gesamtgebühr', display_price(invoice.items.sum)]]
  end

  # def positions_sum_options
  #   {
  #     width: bounds.right,
  #     column_widths: { 1 => 90 },
  #     cell_style: { border_width: 0, padding: [2, 5] }
  #   }
  # end

  def write_footer
    repeat(:all) do
      font font.name, size: 9, style: :italic
      box_width = bounds.right / 3
      small_box_options = { width: box_width - 10, height: @margin_bottom }
      wide_box_options = { width: box_width + 5, height: @margin_bottom }
      box1_position = 0
      box2_position = box1_position + small_box_options[:width]
      box3_position = box2_position + wide_box_options[:width]

      bounding_box([box1_position, 0], small_box_options) { text company.contact_lines }
      bounding_box([box2_position, 0], wide_box_options)  { text company.legal_info_lines }
      bounding_box([box3_position, 0], wide_box_options)  { text company.bank_info_lines }
    end
  end

end
