require 'rails_helper'

RSpec.describe "RoutineExercises", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/routine_exercises/new"
      expect(response).to have_http_status(:success)
    end
  end

end
