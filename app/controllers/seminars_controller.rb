class SeminarsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_seminar, only: [:show, :edit, :update, :destroy, :attendees, :pras]

  def index
    authorize Seminar
    redirect_to action: :category
  end

  def category
    authorize Seminar
    category_id = params[:id]
    redirect_to(category_seminars_url(Category.cat_parents.first)) && return unless category_id
    @category = Category.find(category_id)
    @seminars = @category.all_seminars.order(:number).page(params[:page])
                         .includes(:teachers, :events, :location).all
  end

  def date
    authorize Seminar
    @years    = Seminar.group(:year).count.sort.to_h
    @year     = (params[:year] || Date.current.year).to_i
    @month    = params[:month]
    @seminars = Seminar.order(:date).by_date year: @year, month: @month
    @seminars = @seminars.includes(:teachers, :events, :location).all
  end

  def calendar
    authorize Seminar
    @years          = Seminar.group(:year).count.sort.to_h
    @year           = (params[:year] || Date.current.year).to_i
    @month          = (params[:month] || Date.current.month).to_i
    @first_of_month = Date.new @year, @month
    @events         = Event.order(:date).includes(:seminar).where('date between ? and ?', @first_of_month, @first_of_month.end_of_month)
    @seminars       = Seminar.where(id: @events.select(:seminar_id))
  end

  def canceled
    authorize Seminar
    @seminars = Seminar.where(canceled: true).page(params[:page])
  end

  def show
  end

  def new
    authorize Seminar
    attrs = {}
    if params[:copy_from].present? && (sem = Seminar.find(params[:copy_from]))
      attrs = sem.attributes.except('id').merge(categories: sem.categories, teachers: sem.teachers)
    end
    @seminar = Seminar.new attrs
    10.times { @seminar.events.build }
  end

  def edit
    10.times { @seminar.events.build }
  end

  def create
    authorize Seminar
    @seminar = Seminar.new seminar_params

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
    @attendees = @seminar.attendees.booked.order(:created_at)
  end

  def pras

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seminar
    @seminar = Seminar.unscoped.find params[:id]
    authorize @seminar
  end

  # Only allow a trusted parameter "white list" through.
  def seminar_params
    attrs = [
      :number, :year, :title, :subtitle, :benefit, :content, :notes, :price, :price_text, :key_words,
      :parent_id, :date_text, :max_attendees, :location_id, :archived, :published, :canceled,
      teacher_ids: [], category_ids: [],
      events_attributes: [:id, :location_id, :date, :start_time, :end_time, :notes],
      statistic: AttendeeStatistic.attribute_set.map(&:name)
    ]
    params.require(:seminar).permit(attrs)
  end
end
