class AddPriceInfoToSeminars < ActiveRecord::Migration[5.0]
  def change
    change_table :seminars do |t|
      t.jsonb :price_info, default: '{}'
    end
  end
end
