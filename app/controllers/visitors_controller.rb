class VisitorsController < ApplicationController
  def index
    if user_signed_in?
      redirect_to seminars_url
    else
      redirect_to new_user_session_url
    end
  end
end
