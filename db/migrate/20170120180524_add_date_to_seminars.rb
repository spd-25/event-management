class AddDateToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :date, :date, index: true
  end
end
