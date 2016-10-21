class PublishAllExistingSeminars < ActiveRecord::Migration[5.0]
  def up
    Seminar.unscoped.update_all published: true
  end

  def down
  end
end
