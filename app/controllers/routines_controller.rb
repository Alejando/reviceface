# frozen_string_literal: true

class RoutinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_routine, only: %i[show edit update destroy]
  before_action :current_clinic

  def index
    @pagy, @routines = pagy(current_clinic.routines)
  end

  def show; end

  def new
    @routine = Routine.new
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
      redirect_to routines_path, notice: t('routines.flash.destroy.success')
    else
      redirect_to @routine, alert: @routine.errors.full_messages.join(', ')
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
