module Admin
  class DashboardController < BaseController
    skip_after_action :verify_authorized

    def show
    end

  end
end
