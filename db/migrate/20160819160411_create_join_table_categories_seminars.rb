class CreateJoinTableCategoriesSeminars < ActiveRecord::Migration[5.0]
  def change
    create_join_table :categories, :seminars, column_options: { index: true }
    add_foreign_key :categories_seminars, :categories, on_delete: :cascade
    add_foreign_key :categories_seminars, :seminars, on_delete: :cascade
  end
end
