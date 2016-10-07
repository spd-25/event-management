class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_paper_trail_whodunnit

  private

  def user_not_authorized
    flash[:alert] = 'Du bist nicht berechtigt, diese Seite zu sehen.'
    redirect_to (request.referrer || root_path)
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    seminare_visitor_path
  end
end
