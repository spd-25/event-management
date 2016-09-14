class AddPriceToSeminars < ActiveRecord::Migration[5.0]
  def change
    change_table :seminars do |t|
      t.float :price
      t.float :price_reduced
    end
  end
end
