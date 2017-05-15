class AddParentIdToCategories < ActiveRecord::Migration[5.0]
  def change
    change_table :categories do |t|
      t.integer :parent_id, index: true
    end
  end
end
