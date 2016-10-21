class AddPublishedToSeminars < ActiveRecord::Migration[5.0]
  def change
    change_table :seminars do |t|
      t.boolean :published, default: false, index: true
    end
  end
end
