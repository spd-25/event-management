module UsersHelper
  def roles_select_options
    User::ROLES.map { |role| [translate_role(role), role.to_s] }
  end

  def display_roles_for(user)
    user.roles.map { |role| translate_role(role) }
  end

  def translate_role(role)
    t("users.roles.#{role}")
  end
end
