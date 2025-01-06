class RoutineExercise < ApplicationRecord
  belongs_to :routine
  belongs_to :exercise

  validates :routine, :exercise, :repetitions, :series, :rest_time, :order, presence: true
  validates :routine, :exercise, uniqueness: { scope: :order }

  before_validation :set_default_order, on: :create

  private

  def set_default_order
    self.order ||= routine.routine_exercises.maximum(:order).to_i + 1
  end
end
