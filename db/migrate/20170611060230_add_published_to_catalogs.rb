class AddPublishedToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :published, :boolean, default: false
  end
end
