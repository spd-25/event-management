module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized

    layout 'admin'

  end
end
