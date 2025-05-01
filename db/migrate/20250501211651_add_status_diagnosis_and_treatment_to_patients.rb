class AddStatusDiagnosisAndTreatmentToPatients < ActiveRecord::Migration[8.0]
  def change
    add_column :patients, :status, :string
    add_column :patients, :diagnosis, :text
    add_column :patients, :treatment, :text
  end
end
