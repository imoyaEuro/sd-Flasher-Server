require 'rails_helper'

RSpec.describe Package, type: :model do
  describe "creating a new Package with invalid url" do
    it "should fail" do
      begin
        package = FactoryGirl.create(Package,:name => "Portal package",:price => 50,:logo=> "asdfasdf")
      rescue
        package = nil
      end
      expect(package).to eq(nil)
    end
  end

end
