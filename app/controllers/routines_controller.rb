# frozen_string_literal: true

class RoutinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_routine, only: %i[show edit update destroy]
  before_action :current_clinic

  def index
    @q = current_clinic.routines.ransack(params[:q])
    @q.sorts = "name asc" if @q.sorts.blank?

    respond_to do |format|
      format.html do
        @pagy, @routines = pagy(@q.result)
      end

      format.turbo_stream do
        @pagy, @routines = pagy(@q.result)
        render turbo_stream: turbo_stream.replace(
          "table_with_pagination",
          partial: "routines/table_with_pagination",
          locals: { routines: @routines, pagy: @pagy, q: @q }
        )
      end
    end
  end

  def show; end

  def new
    @routine = Routine.new
    @routine.patient_id = params[:patient_id] if params[:patient_id].present?
    @routine.routine_exercises.build
  end

  def create
    @routine = Routine.new(routine_params)
    if @routine.save
      redirect_to @routine, notice: t('routines.flash.create.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @routine.update(routine_params)
      redirect_to routines_path, notice: t('routines.flash.update.success')
    else
      render :edit
    end
  end

  def destroy
    if @routine.destroy
      respond_to do |format|
        format.html { redirect_to routines_path, notice: t('routines.flash.destroy.success') }
        format.turbo_stream do
          flash.now[:notice] = t('routines.flash.destroy.success')
          @q = current_clinic.routines.ransack(params[:q])
          @q.sorts = "name asc" if @q.sorts.blank?
          @pagy, @routines = pagy(@q.result)
          render turbo_stream: [
            turbo_stream.update('table_with_pagination', 
                              partial: 'routines/table_with_pagination',
                              locals: { routines: @routines, pagy: @pagy, q: @q }),
            turbo_stream.update('notifications', partial: 'shared/notifications')
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @routine, alert: t('routines.errors.destroy.not_allowed') }
        format.turbo_stream do
          flash.now[:alert] = t('routines.errors.destroy.not_allowed')
          render turbo_stream: turbo_stream.update('notifications', partial: 'shared/notifications')
        end
      end
    end
  end

  private

  def set_routine
    @routine = current_clinic.routines.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(
      :name, :description, :start_at, :patient_id,
      routine_exercises_attributes: %i[id exercise_id repetitions series rest_time notes feedback]
    )
  end
end
