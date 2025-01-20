# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: %i[edit update show]

  def index
    @pagy, @patients = pagy(current_clinic.patients.order_by_user_status_and_name)
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
