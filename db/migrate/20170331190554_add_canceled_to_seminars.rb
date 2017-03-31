class AddCanceledToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :canceled, :boolean, default: false
  end
end
