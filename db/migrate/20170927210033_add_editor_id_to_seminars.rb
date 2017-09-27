class AddEditorIdToSeminars < ActiveRecord::Migration[5.0]
  def change
    change_table :seminars do |t|
      t.integer :editor_id, index: true
    end
  end
end
