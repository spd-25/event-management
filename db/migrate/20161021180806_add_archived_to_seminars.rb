class AddArchivedToSeminars < ActiveRecord::Migration[5.0]
  def change
    change_table :seminars do |t|
      t.boolean :archived, default: false, index: true
    end
  end
end
