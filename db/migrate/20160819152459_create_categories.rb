class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name, index: true
      t.references :category
    end
    add_foreign_key :categories, :categories, on_delete: :cascade
  end
end
