# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: %i[edit update show]

  def index
    set_patients_with_pagination
    @new_patient = current_clinic.patients.new
    @new_patient.build_user

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("table_with_pagination",
                                                  partial: "patients/table_with_pagination",
                                                  locals: { patients: @patients, pagy: @pagy, q: @q })
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
      @new_patient = current_clinic.patients.new
      @new_patient.build_user

      respond_to do |format|
        format.turbo_stream do
          set_patients_with_pagination

          render turbo_stream: [
            turbo_stream.replace("table_with_pagination",
                                partial: "patients/table_with_pagination",
                                locals: { patients: @patients, pagy: @pagy, q: @q }),
            turbo_stream.replace("notifications",
                               render_to_string(NotificationComponent.new(
                                 type: :success,
                                 message: t('patients.flash.create.success')
                               ))),
            turbo_stream.replace("new_patient_form_container",
                               partial: "patients/modal_form",
                               locals: { new_patient: @new_patient })
          ]
        end
        format.html { redirect_to patients_path, notice: t('patients.flash.create.success') }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_patient_form_container",
                                                    partial: "patients/modal_form",
                                                    locals: { new_patient: @patient }), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "edit_patient_form_container",
          partial: "patients/edit_modal_form",
          locals: { patient: @patient }
        )
      end
    end
  end

  def update
    if @patient.update(patient_params)
      respond_to do |format|
        format.turbo_stream do
          set_patients_with_pagination

          render turbo_stream: [
            turbo_stream.replace("table_with_pagination",
                                partial: "patients/table_with_pagination",
                                locals: { patients: @patients, pagy: @pagy, q: @q }),
            turbo_stream.replace("notifications",
                               render_to_string(NotificationComponent.new(
                                 type: :success,
                                 message: t('patients.flash.update.success')
                               )))
          ]
        end
        format.html { redirect_to patients_path, notice: t('patients.flash.update.success') }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "edit_patient_form_container",
            partial: "patients/edit_modal_form",
            locals: { patient: @patient }
          ), status: :unprocessable_entity
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
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

  def set_patients_with_pagination
    @q = current_clinic.patients.ransack(params[:q])
    @q.sorts = "user_first_name asc" if @q.sorts.blank?

    # Ensure columns used for sorting are in the SELECT list when using DISTINCT
    patients_relation = @q.result(distinct: true)
                          .includes(user: { profile_photo_attachment: :blob })
                          .select("patients.*, users.first_name, users.last_name")

    @pagy, @patients = pagy(patients_relation, items: 10)
  end
end
