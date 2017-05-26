require 'rails_helper'


RSpec.describe ApiGamesController, type: :controller do

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
  end

  context "with invalid api_token" do
    describe "GET #index" do
      it "should return unauthorized and a json with error 4" do
        get :index, {:api_token => "asdf" }
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(4)
      end
    end
  end

  context "with valid api_token" do
    describe "GET #index" do
      it "should return success" do
        get :index, {:api_token => GimmeApiTokenFrom.anyone }
        expect(response).to have_http_status :success
      end

      it "should return an array with games" do
        get :index, {:api_token => GimmeApiTokenFrom.anyone }

        json=JSON.parse(response.body)
        expect(json.class).to be(Array)
        expect(json.count).to be(9)
        json.each do |game|
          expect(game["id"].class).to be(Fixnum)
          expect(game["name"].class).to be(String)
          expect(game["version"].class).to be(Fixnum)
        end
      end
    end
  end

  context "from the tablet, obtaining gamekey" do
    describe "POST #show with invalid key/tablet convination" do
      it "should return error 10 (invalid key/tablet convination" do
        post :show, {:id => 1, :key => "j9838933j89", :tablet => "ajosfjf2j0"}
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(10)
      end
    end

    describe "POST #show with tablet. but missing key missing" do
      it "should return error 5" do
        post :show, {:id => 1, :tablet => "asf23fsd"}
        expect(response).to have_http_status :bad_request
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(5)
      end
    end

    describe "POST #show with tablet. but missing key and tablet" do
      it "should return error 5" do
        post :show, {:id => 1}
        expect(response).to have_http_status :bad_request
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(11)
      end
    end
    describe "POST #show with key. but missing tablet id missing" do
      it "should return error 5" do
        post :show, {:id => 1, :key => "asf23fsd"}
        expect(response).to have_http_status :bad_request
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(7)
      end
    end


    describe "POST #show with valid tablet/key but invalid game" do
      it "should return a json with id, name and gamekey" do
        post :show, {:id => 213412341,:tablet => "asdf", :key => "asf23fsd"}
        expect(response).to have_http_status :not_found
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(12)
      end
    end

    describe "POST #show with valid tablet/key/game but for a game that the provider didn't flash" do
      it "should return a json with id, name and gamekey" do
        post :show, {:id => Game.where(:name => "Counter Strike").first.id,:tablet => "1234567", :key => "123455"}
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(13)
      end
    end

    describe "POST #show with valid tablet/key/gameid" do
      it "should return a json with id, name and gamekey" do
        post :show, {:id => Game.where(:name =>"Pacman").first.id ,:tablet => "1234567", :key => "123455"}
        expect(response).to have_http_status :success
        expect(response.body).to have_json_path("id")
        expect(response.body).to have_json_type(Integer).at_path("id")
        expect(response.body).to have_json_path("gamekey")
        expect(response.body).to have_json_type(String).at_path("gamekey")
        expect(response.body).to have_json_path("name")
        expect(response.body).to have_json_type(String).at_path("name")
      end
    end
  end
end
