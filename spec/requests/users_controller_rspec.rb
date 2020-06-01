require "rails_helper"

RSpec.describe "API::UsersController", type: :request do
    descripte "GET /api/users/:id" do
        let(:user) { create(username: Faker::Name.unique.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length = 8, max_length = 16, mix_case = true, special_chars = true))}
    end

    it "returns http ok" do
        expect(response).to have_http_status(:ok)
    end

    it "returns 200 if the user id is found" do
        # todo
    end
end