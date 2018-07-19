module Admin
  class SearchController < BaseController
    def index
      authorize :search
      @query = params[:q]
      result = PgSearch.multisearch(@query).all.group_by(&:searchable_type)
      @result = {}
      result.each do |type, results|
        case type
        when 'Seminar'
          @result[Seminar] = Seminar.unscoped.where(year: current_year, id: results.map(&:searchable_id))
        else
          model = type.constantize
          @result[model] = model.find results.map(&:searchable_id)
        end
      end
      # @result = @result.select { |s| s.is_a?(Attendee) || (s.respond_to?(:year) ? s.year == current_year : true) }
      # return unless @result.count == 1
      # one_hit = @result.first
      # one_hit = one_hit.booking.seminar if one_hit.is_a?(Attendee)
      # redirect_to [:admin, one_hit]
    end
  end
end
