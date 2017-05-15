class AddPositionToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :position, :integer, index: true, null: false, default: 1
  end
end
