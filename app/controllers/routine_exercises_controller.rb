class RoutineExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_routine
  before_action :set_routine_exercise, only: %i[destroy edit update]

  def new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:[
          turbo_stream.update(:add_exercise_form, partial: "routine_exercises/new_form", locals: { routine_exercise: @routine.routine_exercises.new }),
          turbo_stream.update(:add_routine_buttons, "")
        ]
      end
    end
  end

  def create
    @routine_exercise = @routine.routine_exercises.new(routine_exercise_params)
    if @routine_exercise.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:[
            turbo_stream.append(:routine_exercises, partial: "routine_exercises/routine_exercise_card", locals: { routine_exercise: @routine_exercise }),
            turbo_stream.update(:add_exercise_form, partial: "routine_exercises/new_form", locals: { routine_exercise: @routine.routine_exercises.new })
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:add_exercise_form, partial: "routine_exercises/new_form", locals: { routine_exercise: @routine_exercise }),
            turbo_stream.replace(:resource_errors, partial: "shared/resource_errors", locals: { resource: @routine_exercise })
          ]
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:[
          turbo_stream.update(:add_exercise_form, partial: "routine_exercises/edit_form", locals: { routine_exercise: @routine_exercise }),
          turbo_stream.update(:add_routine_buttons, "")
        ]
      end
    end
  end

  def update
    if @routine_exercise.update(routine_exercise_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:[
            turbo_stream.update(@routine_exercise, partial: "routine_exercises/routine_exercise_card", locals: { routine_exercise: @routine_exercise }),
            turbo_stream.update(:add_exercise_form, ""),
            turbo_stream.update(:add_routine_buttons, partial: "routine_exercises/add_routine_buttons", locals: { routine: @routine })
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:add_exercise_form, partial: "routine_exercises/new_form", locals: { routine_exercise: @routine_exercise }),
            turbo_stream.replace(:resource_errors, partial: "shared/resource_errors", locals: { resource: @routine_exercise })
          ]
        end
      end
    end
  end

  def cancel
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(:add_routine_buttons, partial: "routine_exercises/add_routine_buttons", locals: { routine: @routine }),
          turbo_stream.update(:add_exercise_form, "")
        ]
      end
    end
  end

  def destroy
    @routine_exercise = @routine.routine_exercises.find(params[:id])
    @routine_exercise.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@routine_exercise)
      end
    end
  end

  private

  def set_routine_exercise
    @routine_exercise = @routine.routine_exercises.find(params[:id])
  end

  def set_routine
    @routine = current_clinic.routines.find(params[:routine_id])
  end


  def routine_exercise_params
    params.require(:routine_exercise).permit(
      :exercise_id, :series, :repetitions, :difficulty, :rest_time, :notes
    )
  end
end
