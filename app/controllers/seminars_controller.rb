class SeminarsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_seminar,
                only: %i(show edit update destroy attendees pras versions toggle_category
                         publish unpublish)

  def index
    authorize Seminar
    redirect_to action: :category
  end

  def category
    authorize Seminar
    categories = current_catalog.categories
    @category = categories.find_by(id: params[:id]) || categories.roots.first
    @seminars = @category ? @category.all_seminars : current_catalog.seminars
    @seminars = @seminars.order(:number).includes(:teachers, :events, :location).page(params[:page]).all
  end

  def date
    authorize Seminar
    @month    = params[:month].to_i
    @seminars = current_catalog.seminars.order(:date).by_month(@month)
      .includes(:teachers, :events, :location).all
  end

  def calendar
    authorize Seminar
    @month         = (params[:month] || Date.current.month).to_i
    first_of_month = Date.new current_catalog.year, @month
    @days_of_month = first_of_month..first_of_month.end_of_month
    @events        = Event.order(:date).joins(:seminar).includes(:seminar).where(date: @days_of_month)
    @seminars      = Seminar.where(id: @events.select(:seminar_id))
  end

  def canceled
    authorize Seminar
    @seminars = current_catalog.seminars.canceled.page(params[:page])
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seminar
    @seminar = Seminar.unscoped.find(params[:id]).decorate
    authorize @seminar
  end

  # Only allow a trusted parameter "white list" through.
  def seminar_params
    attrs = %i(number year title subtitle benefit content notes price price_text key_words
               parent_id date_text max_attendees location_id archived canceled copy_from_id)
    attrs << {
      teacher_ids: [],
      events_attributes: [:id, :location_id, :date, :start_time, :end_time, :notes],
      statistic:         AttendeeStatistic.attribute_set.map(&:name)
    }
    params.require(:seminar).permit(attrs)
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
