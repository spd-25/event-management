class MigrateUserRoles < ActiveRecord::Migration[5.1]
  def up
    roles = { user: 0, admin: 1, editor: 2, layouter: 3 }.invert
    User.all.each { |user| user.update roles: [roles[user.role].to_s] }
  end

  def down
    User.update_all roles: []
  end
end
