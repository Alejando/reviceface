# frozen_string_literal: true

class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[edit update]

  def index
    @pagy, @exercises = pagy(Exercise.all)
  end

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = Exercise.new(exercise_params)
    if @exercise.save
      redirect_to exercises_path, notice: t('exercises.flash.create.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @exercise.update(exercise_params)
      redirect_to exercises_path, notice: t('exercises.flash.update.success')
    else
      render :edit
    end
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(
      :name, :description, :video_url, :objective
    )
  end
end
