class AddPrintedPagesToSeminars < ActiveRecord::Migration[5.1]
  def change
    add_column :seminars, :printed_pages, :integer, default: 1
  end
end
