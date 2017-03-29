class AddStatisticToSeminars < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :statistic, :jsonb, default: '{}'
  end
end
