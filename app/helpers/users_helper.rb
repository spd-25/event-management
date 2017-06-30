module UsersHelper
  def roles_select_options
    User.roles.keys.map do |key|
      [t("users.roles.#{key}"), key]
    end.to_h
  end
end
