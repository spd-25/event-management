class CreateCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :catalogs do |t|
      t.string :title, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
