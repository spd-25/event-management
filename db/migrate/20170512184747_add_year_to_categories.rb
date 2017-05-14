class AddYearToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :year, :integer
  end
end
