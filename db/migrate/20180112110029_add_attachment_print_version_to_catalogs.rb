class AddAttachmentPrintVersionToCatalogs < ActiveRecord::Migration[5.1]
  def up
    change_table :catalogs do |t|
      t.attachment :print_version
    end
  end

  def down
    remove_attachment :catalogs, :print_version
  end
end
