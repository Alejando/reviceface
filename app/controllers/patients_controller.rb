# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: %i[edit update show]

  def index
    @q = current_clinic.patients.ransack(params[:q])
    @q.sorts = "user_first_name asc" if @q.sorts.blank?

    respond_to do |format|
      format.html do
        @pagy, @patients = pagy(@q.result)
      end

      format.turbo_stream do
        @pagy, @patients = pagy(@q.result)
        render turbo_stream: turbo_stream.replace(
          "table_with_pagination",
          partial: "patients/table_with_pagination",
          locals: { patients: @patients, pagy: @pagy, q: @q }
        )
      end
    end
  end

  def show; end

  def new
    @patient = current_clinic.patients.new
    @patient.build_user
  end

  def create
    @patient = current_clinic.patients.new(patient_params)
    assign_default_patient_attributes
    if @patient.save
      redirect_to patients_path, notice: t('patients.flash.create.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: t('patients.flash.update.success')
    else
      render :edit
    end
  end

  private

  def set_patient
    @patient = current_clinic.patients.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(
      user_attributes: %i[id first_name last_name email birthdate]
    )
  end

  def assign_default_patient_attributes
    @patient.user.role = :patient
    @patient.user.clinic = current_clinic
    @patient.user.skip_password_validation = true
  end
end
