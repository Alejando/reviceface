# frozen_string_literal: true

class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: %i[edit update show]

  def index
    @new_patient = current_clinic.patients.new
    @new_patient.build_user
    set_patients_with_pagination
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("table_with_pagination",
                                                  partial: "patients/table_with_pagination",
                                                  locals: { 
                                                    patients: @patients, 
                                                    pagy: @pagy, 
                                                    q: @q,
                                                    **pagination_and_search_params
                                                  })
      end
    end
  end

  def show; end

  def new
    @patient = current_clinic.patients.new
    @patient.build_user

    respond_to do |format|
      format.html
      format.turbo_stream do
        modal_title = t('patients.new_patient')

        render turbo_stream: [
          turbo_stream.update(
            "patient_form_container",
            partial: "patients/patient_form",
            locals: {
              patient: @patient,
              title: modal_title,
              **pagination_and_search_params
            }
          ),
          turbo_stream.update("patient_modal_title", modal_title)
        ]
      end
    end
  end

  def create
    @patient = current_clinic.patients.new(patient_params)
    assign_default_patient_attributes

    if @patient.save
      @new_patient = current_clinic.patients.new
      @new_patient.build_user

      respond_to do |format|
        format.turbo_stream do
          set_patients_with_pagination(@patient)

          render turbo_stream: [
            turbo_stream.replace("table_with_pagination",
                                partial: "patients/table_with_pagination",
                                locals: { 
                                  patients: @patients, 
                                  pagy: @pagy, 
                                  q: @q,
                                  **pagination_and_search_params 
                                }),
            turbo_stream.replace("notifications",
                               render_to_string(NotificationComponent.new(
                                 type: :success,
                                 message: t('patients.flash.create.success')
                               ))),
            turbo_stream.replace("patient_form_container",
                               partial: "patients/patient_form",
                               locals: {
                                  patient: @new_patient,
                                  title: t('patients.new_patient'),
                                  **pagination_and_search_params
                               })
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("patient_form_container",
                                                  partial: "patients/patient_form",
                                                  locals: {
                                                     patient: @patient,
                                                     title: t('patients.new_patient'),
                                                     **pagination_and_search_params
                                                   }), status: :unprocessable_entity
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        # Preparar título con nombre del paciente
        patient_name = @patient.user&.full_name || @patient.id.to_s
        modal_title = t('patients.edit_patient_with_name', name: patient_name)
        
        render turbo_stream: [
          turbo_stream.update(
            "patient_form_container",
            partial: "patients/patient_form",
            locals: {
              patient: @patient,
              title: modal_title,
              **pagination_and_search_params
            }
          ),
          turbo_stream.update("patient_modal_title", modal_title)
        ]
      end
    end
  end

  def update
    if @patient.update(patient_params)
      respond_to do |format|
        format.turbo_stream do
          params[:page] = params[:page].presence || 1
          set_patients_with_pagination
          search_locals = {}
          if params[:q].present?
            search_locals[:search_params] = params[:q]
          end

          render turbo_stream: [
            turbo_stream.replace("table_with_pagination",
                                partial: "patients/table_with_pagination",
                                locals: { 
                                  patients: @patients, 
                                  pagy: @pagy, 
                                  q: @q,
                                  page_param: params[:page],
                                  **search_locals
                                }),
            turbo_stream.replace("notifications",
                               render_to_string(NotificationComponent.new(
                                 type: :success,
                                 message: t('patients.flash.update.success')
                               )))
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "patient_form_container",
            partial: "patients/patient_form",
            locals: {
              patient: @patient,
              title: t('patients.edit_patient')
            }
          ), status: :unprocessable_entity
        end
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

  def set_patients_with_pagination(record = nil)
    @q = current_clinic.patients.ransack(params[:q])
    @q.sorts = "user_first_name asc" if @q.sorts.blank?

    patients_relation = @q.result(distinct: true)
                          .includes(user: { profile_photo_attachment: :blob })
                          .select("patients.*, users.first_name, users.last_name")

    if record
      position = patients_relation.index(record)
      page = (position / 10).ceil + 1
      params[:page] = page
    end

    total_count = patients_relation.size
    per_page = 10
    total_pages = (total_count.to_f / per_page).ceil

    requested_page = params[:page].to_i
    requested_page = 1 if requested_page <= 0

    if total_pages > 0 && requested_page > total_pages
      requested_page = 1
    end

    @pagy, @patients = pagy(patients_relation, items: per_page, page: requested_page)
  end

  def pagination_and_search_params
    {
      page_param: params[:page],
      search_params: params[:q]
    }
  end
end
