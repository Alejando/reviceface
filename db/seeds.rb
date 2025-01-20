# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a clinic
clinic = Clinic.find_or_create_by!(name: "CUValles", status: "active")

# Create Admins

%w[terapista1@mail.com terapista2@mail.com].each do |email|
  User.find_or_create_by!(email: email).tap do |user|
    user.first_name = Faker::Name.first_name
    user.last_name = Faker::Name.last_name
    user.birthdate = Faker::Date.birthday(min_age: 18, max_age: 65)
    user.password = "password1"
    user.role = :doctor
    user.clinic = clinic
    user.confirm if user.confirmed_at.nil?
  end
end


# Create Patients confirmed
20.times do
 Patient.new.tap do |patient|
    patient.user = User.new.tap do |user|
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.email = Faker::Internet.email
      user.birthdate = Faker::Date.birthday(min_age: 18, max_age: 65)
      user.password = "password1"
      user.role = :patient
      user.clinic = clinic
    end
    patient.clinic = clinic
    if Faker::Boolean.boolean(true_ratio: 0.8)
      patient.agree_terms_at = Time.zone.now
      patient.agree_privacy_at = Time.zone.now
    end
    patient.save!
 end
end


# create exercises

20.times do |i|
  Exercise.find_or_create_by!(name: "Ejercicio #{i + 1 }").tap do |exercise|
    exercise.description = Faker::Lorem.paragraph
    exercise.video_url = "https://www.youtube.com"
    exercise.objective = Faker::Lorem.sentence
    exercise.save!
  end
end


Patient.all.each do |patient|
  week = 1
  routine = Routine.new.tap do |routine|
    routine.name = "Rutina de la semana #{week}"
    routine.description = Faker::Lorem.paragraph
    routine.start_at = Time.zone.now + (week - 1).weeks
    routine.patient = patient
    routine.save!
  end

  Exercise.take(5).each do |exercise|
    RoutineExercise.new.tap do |routine_exercise|
      routine_exercise.exercise = exercise
      routine_exercise.repetitions = rand(10..20)
      routine_exercise.series = rand(3..5)
      routine_exercise.rest_time = rand(30..60)
      routine_exercise.routine = routine
      routine_exercise.save!
    end
  end
  week += 1
end