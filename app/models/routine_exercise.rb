class RoutineExercise < ApplicationRecord
  belongs_to :routine
  belongs_to :exercise

  validates :exercise, :repetitions, :series, :rest_time, :order, presence: true
  validates :exercise, uniqueness: { scope: :routine_id }

  before_validation :set_default_order, on: :create

  private

  def set_default_order
    self.order ||= routine.routine_exercises.maximum(:order).to_i + 1
  end
end
