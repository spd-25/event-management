class AddKeyWordsToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :key_words, :text
  end
end
