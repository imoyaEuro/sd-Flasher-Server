require 'rails_helper'

RSpec.describe ApiSdPackagesController, type: :controller do
  context "with invalid SdPackage key" do
    describe "POST #tablet" do
      it "should return error 6 (SdPackage key not found)" do
        post :tablet, {:key => "EXAMPLE_OF_SD_CARD_SERIAL_THAT_IS_NOT_IN_THE_DATABASE", :tablet => "tabletid2342342342"}
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(6)
      end
    end
  end

  context "with tablet id missing" do
    describe "POST #tablet" do
      it "should return error 7 (Tablet id missing)" do
        post :tablet, {:key => "valid_or_invalid_key"}#tablet => "something" missing
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(7)
      end
    end
  end

  context "with tablet id not matching the one assigned to a valid SdPackage key" do
    describe "POST #tablet" do
      it "should return error 8 (Tablet id does not correspond to the one assigned to this SdPackage" do
        post :tablet, {:key => "1234", :tablet => "something_not_matching_what_is_in_the_db"}
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(8)
      end
    end
  end

  context "with key id missing" do
    describe "POST #tablet" do
      it "should return error 5 (key missing)" do
        post :tablet, {:tablet => "something"}#key => "something" missing
        expect(response.body).to have_json_path("error")
        expect(response.body).to have_json_type(Integer).at_path("error")
        expect(JSON.parse(response.body)["error"]).to eq(5)
      end
    end
  end

  context "with valid SdPackage key and valid tablet id" do
    describe "POST #tablet" do
      it "should return all games associated" do
        post :tablet, {:key => "1234", :tablet => "123456"}
        expect(response.body).to have_json_path("games")
        expect(JSON.parse(response.body)["games"].length).to eq(4)
      end
    end
  end

  context "with valid SdPackage key, and a tablet id, when there is no tablet id associated in the DB with the SdPackage key" do
    describe "POST #tablet" do
      it "should return all games associated and add tablet id" do
        post :tablet, {:key => "1235", :tablet=> "123456"}
        expect(response.body).to have_json_path("games")
        expect(SdPackage.where(:key => "1235").first.tablet).to eq("123456")
        expect(JSON.parse(response.body)["games"].length).to eq(2)
      end
    end
  end
end

