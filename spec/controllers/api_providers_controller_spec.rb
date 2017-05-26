require 'rails_helper'


RSpec.describe ApiProvidersController, type: :controller do

  context "without session started" do
    describe "GET #me" do
      it "should return unauthorized and a json with error 3" do
        get :me
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(3)
      end
    end
  end

  context "with invalid api_token" do
    describe "GET #me" do
      it "should return unauthorized and a json with error 4" do
        get :me, {:api_token => "asdf" }
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(4)
      end
    end
  end

    context "with valid api_token" do
      describe "GET #me" do
        it "should return success" do
          get :me, {:api_token => GimmeApiTokenFrom.anyone }
          expect(response).to have_http_status :success
        end

        it "should return json with email and credit" do
          get :me, {:api_token => GimmeApiTokenFrom.anyone }

          json=JSON.parse(response.body)
          expect(json["email"].class).to be(String)
          expect(json["credit"].class).to be(Fixnum)
        end
      end
    end
  end
