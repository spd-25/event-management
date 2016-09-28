class AddParentToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_reference :seminars, :parent, foreign_key: { to_table: :seminars }
  end
end
