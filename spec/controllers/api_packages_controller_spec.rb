require 'rails_helper'


RSpec.describe ApiPackagesController, type: :controller do
  #	packages_games_providers_setup

  context "without session started" do
    describe "GET #index" do
      it "should return unauthorized and a json with error 3" do
        get :index
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(3)
      end
    end
    describe "GET #show" do
      it "should return unauthorized and a json with error 3" do
        get :show, :id => 1
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(3)
      end
    end
    describe "POST #buy" do
      it "should return unauthorized and a json with error 3" do
        post :buy, :id => 1
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(3)
      end
    end
  end

  context "with invalid api_token" do
    describe "GET #index" do
      it "should return aunauthorized and a json with error 4" do
        get :index, {:api_token => "asdf" }
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(4)
      end
    end
    describe "GET #show" do
      it "should return unauthorized" do
        get :show, {:id => 1, :api_token => "asdf"}
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(4)
      end
    end
    describe "POST #buy" do
      it "should return unauthorized" do
        post :buy, {:id => 1, :api_token => "asdf"}
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(4)
      end
    end
  end

  context "with SdPackage key already in use" do
    describe "POST #buy" do
      it "should return error 9 (sdpackage key already in use)" do
        post :buy, {:id => 1, :api_token => GimmeApiTokenFrom.rich, :key => "1234"}
        expect(response.body).to have_json_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(9)
      end
    end
  end

  context "with valid api_token" do
    describe "GET #index" do
      it "should return success" do
        get :index, {:api_token => GimmeApiTokenFrom.anyone }
        expect(response).to have_http_status :success
      end

      it "response should be an array" do
        get :index, {:api_token => GimmeApiTokenFrom.anyone }
        json=JSON.parse(response.body)
        expect(json.class).to be(Array)
        expect(json.count).to be(3)
        json.each do |package|
          expect(package["id"].class).to be(Fixnum)
          expect(package["name"].class).to be(String)
          expect(package["price"].class).to be(Fixnum)
        end 
      end
    end
    describe "GET #show" do

      it "should return success" do
        get :show, {:id => 1, :api_token => GimmeApiTokenFrom.anyone }
        expect(response).to have_http_status :success
      end

      it "response should return a package" do
        get :show, {:id => 1, :api_token => GimmeApiTokenFrom.anyone }
        json=JSON.parse(response.body)
        expect(response.body).to have_json_path("package")
      end

      it "response should return a games" do
        get :show, {:id => 1, :api_token => GimmeApiTokenFrom.anyone }
        json=JSON.parse(response.body)
        expect(response.body).to have_json_path("games")
      end

      it "response should have games with name and description" do
        get :show, {:id => 1, :api_token => GimmeApiTokenFrom.anyone }
        json=JSON.parse(response.body)
        for i in 0..(json["games"].count-1)
          expect(response.body).to have_json_path("games/#{i}/name")
          expect(response.body).to have_json_path("games/#{i}/description")
        end
      end

      it "should return games without keys" do
        get :show, {:id => 1, :api_token => GimmeApiTokenFrom.anyone }
        json=JSON.parse(response.body)
        json["games"].each do |game|
          expect(game["key"]).to eq(nil)
        end
      end

    end

    describe "POST #buy" do
      it "should return success" do
        post :buy, {:id => 1, :api_token => GimmeApiTokenFrom.rich, :key => "asdfasdf"}
        expect(response).to have_http_status :success
      end

      it "should return status ok" do
        post :buy, {:id => 1, :api_token => GimmeApiTokenFrom.rich, :key => "asdfasdf"}
        json=JSON.parse(response.body)
        expect(json["status"]).to eq("ok")
      end

      it "Sale.count should increase by one" do
        expect{
          post :buy, {:id => 1, :api_token => GimmeApiTokenFrom.rich, :key => "asdfasdf"}
        }.to change{Sale.count}.by(+1)
      end
    end
  end

  context "with valid api_token. requesting invalid data" do
    describe "GET #show sending non-exitent id" do
      it "should return 404" do
        get :show, {:id => 9999999999, :api_token => GimmeApiTokenFrom.anyone }
        expect(response).to have_http_status :not_found
      end
    end

    describe "POST #buy without giving sd-card key" do
      it "should return bad request" do
        post :buy, {:id => 1, :api_token => GimmeApiTokenFrom.anyone }
        expect(response).to have_http_status :bad_request
      end
    end
  end

  context "with valid api_token, but no credits" do
    describe "POST #buy" do
      it "should return error 1. not enough credits" do
        post :buy, {:id => 1, :api_token => GimmeApiTokenFrom.poor, :key => "asdf"}
        expect(response).to have_http_status :success
      end

      it "should return error 1. not enough credits" do
        post :buy, {:id => 1, :api_token => GimmeApiTokenFrom.poor, :key => "asdf"}
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(1)
      end
    end
  end
end
