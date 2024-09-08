require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) } # using factorybot

  describe "POST signup" do
      it "creates a new user" do
          inital_count = User.count
          post "/api/v1/authentication/signup", params: { email: "test@example.com", password: "123" }

          expect(response).to have_http_status :created
          expect(JSON.parse(response.body)).to include("success" => true)
          expect(User.count).to eq(inital_count + 1)
          expect(User.last.email).to eq('test@example.com')
      end

      it "returns errors for invalid signup" do
        post "/api/v1/authentication/signup", params: { email: "", password: "123" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Email can't be blank")
        expect(JSON.parse(response.body)).to include("success" => false)
      end
    end

    describe "POST login" do
        it "authenticates the user with valid credentials" do
            post "/api/v1/authentication/login", params: { email: user.email, password: user.password }
            expect(response).to have_http_status :ok
            expect(response.body).to include("token")
            expect(JSON.parse(response.body)).to include("success" => true)
        end

        it "returns errors for invalid login" do
          post '/api/v1/authentication/login', params: { email: user.email, password: "wrong password" }
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to include("success" => false)
          expect(response.body).to include("errors")
          expect(JSON.parse(response.body)).to include({ "errors" => "Invalid Email Or Password" })
        end
    end
end
