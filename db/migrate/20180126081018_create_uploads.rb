class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.attachment :upload_file
      t.string :name
      t.references :user

      t.timestamps
    end
  end
end
