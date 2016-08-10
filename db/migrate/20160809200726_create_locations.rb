class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :short
      t.jsonb :address, default: '{}'

      t.timestamps
    end
  end
end
