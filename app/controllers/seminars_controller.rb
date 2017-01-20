class SeminarsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_seminar, only: [:show, :edit, :update, :destroy]

  def index
    authorize Seminar

    @by = params[:by] || 'category'

    case @by
    when 'category'
      category_id = params[:category_id]
      @category   = category_id ? Category.find(category_id) : Category.cat_parents.first
      @seminars   = (@category ? @category.all_seminars : Seminar).order(:number).page(params[:page])
    when 'date'
      @years    = Seminar.group(:year).count.sort.to_h
      @year     = (params[:year] || Date.current.year).to_i
      @month    = params[:month]
      @seminars = Seminar.by_date year: @year, month: @month
    end
    @seminars = @seminars.includes(:teachers, :events, :location).all
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seminar
    @seminar = Seminar.unscoped.find params[:id]
    authorize @seminar
  end

  # Only allow a trusted parameter "white list" through.
  def seminar_params
    attrs = [
      :number, :year, :title, :subtitle, :benefit, :content, :notes, :price, :price_text,
      :parent_id, :date_text, :max_attendees, :location_id, :archived, :published,
      teacher_ids: [], category_ids: [],
      events_attributes: [:id, :location_id, :date, :start_time, :end_time, :notes]
    ]
    params.require(:seminar).permit(attrs)
  end
end
