class SearchController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize :search
    @query = params[:q]
    @result = PgSearch.multisearch(@query).includes(:searchable).to_a.map(&:searchable)
    @result = @result.select { |s| s.is_a?(Attendee) || (s.respond_to?(:year) ? s.year == current_year : true) }
    if @result.count == 1
      one_hit = @result.first
      redirect_to one_hit.is_a?(Attendee) ? one_hit.booking.seminar : one_hit
    end
  end
end
