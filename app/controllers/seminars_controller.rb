class SeminarsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_seminar,
                only: %i(show edit update destroy attendees pras versions toggle_category
                         publish unpublish finish_editing finish_layout)

  def index
    authorize Seminar
    redirect_to action: (current_user.layouter? ? :layout : :category)
  end

  def category
    authorize Seminar
    categories              = current_catalog.categories
    @category               = categories.find_by(id: params[:id])
    seminars                = current_catalog.seminars
    @uncategorized_seminars = seminars.where.not(id: seminars.joins(:categories).select(:id))
    @seminars               = @category ? @category.all_seminars : @uncategorized_seminars
    @seminars               = @seminars.page(params[:page])
  end

  def date
    authorize Seminar
    @month    = params[:month].to_i
    @seminars = current_catalog.seminars.by_month(@month).page(params[:page])
  end

  def calendar
    authorize Seminar
    @month         = (params[:month] || Date.current.month).to_i
    first_of_month = Date.new current_catalog.year, @month
    @days_of_month = first_of_month..first_of_month.end_of_month
    @events        = Event.order(:date).joins(:seminar).includes(:seminar)
      .where(date: @days_of_month)
    @seminars      = Seminar.where(id: @events.select(:seminar_id)).page(params[:page])
  end

  def canceled
    authorize Seminar
    @seminars = current_catalog.seminars.canceled.page(params[:page])
  end

  def editing_status
    authorize Seminar
    @scopes   = %i(all editing_not_finished layout_open completed layout_changed)
    @scope    = params[:scope].to_s.to_sym
    @scope    = @scopes.first unless @scope.in? @scopes
    @seminars = current_catalog.seminars.page(params[:page]).send @scope
  end

  def show
  end

  def new
    authorize Seminar
    @seminar = Seminar.new new_seminar_params
    10.times { @seminar.events.build }
  end

  def edit
    10.times { @seminar.events.build }
  end

  def create
    authorize Seminar
    @seminar = Seminar.new seminar_params
    @seminar.year = current_year
    copy_data_for @seminar

    if @seminar.save
      redirect_to @seminar, notice: t(:created, model: Seminar.model_name.human)
    else
      10.times { @seminar.events.build }
      render :new
    end
  end

  def update
    if @seminar.update seminar_params
      redirect_to @seminar, notice: t(:updated, model: Seminar.model_name.human)
    else
      10.times { @seminar.events.build }
      render :edit
    end
  end

  def destroy
    @seminar.destroy
    redirect_to seminars_url, notice: t(:destroyed, model: Seminar.model_name.human)
  end

  def attendees
    @attendees = @seminar.attendees.order(:created_at)
  end

  def pras
  end

  def versions
  end

  def toggle_category
    if (category = Category.find params[:category_id])
      if category.in? @seminar.categories
        @seminar.categories.delete category
      else
        @seminar.categories << category
      end
    end
  end

  def search
    authorize Seminar
  end

  def publish
    @seminar.update published: true
    redirect_to @seminar, notice: 'Seminar freigegeben.'
  end

  def unpublish
    @seminar.update published: false
    redirect_to @seminar, notice: 'Seminar deaktiviert.'
  end

  def finish_editing
    @seminar.finish_editing!
    redirect_to @seminar, notice: 'Bearbeitung abgeschlossen'
  end

  def finish_layout
    @seminar.finish_layout!
    redirect_to @seminar, notice: 'Layout abgeschlossen'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seminar
    @seminar = Seminar.unscoped.find(params[:id]).decorate
    authorize @seminar
  end

  # Only allow a trusted parameter "white list" through.
  def seminar_params
    params.require(:seminar).permit policy(Seminar).permitted_attributes
  end

  def new_seminar_params
    attrs = {}
    if params[:copy_from].present? && (sem = Seminar.find(params[:copy_from]))
      attrs = sem.attributes.except('id', 'published').merge(
        teachers:     sem.teachers,
        copy_from_id: sem.id
      )
    end
    attrs[:year] = current_year
    attrs
  end

  def copy_data_for(seminar)
    return unless seminar.original.present? && seminar.year == seminar.original.year
    seminar.categories = seminar.original.categories
  end
end
