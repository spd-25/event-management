require Rails.root.join 'db', 'migrate', '20170328185035_add_statistic_to_seminars.rb'
class RemoveStatisticFromSeminars < ActiveRecord::Migration[5.1]
  def change
    revert AddStatisticToSeminars
  end
end
