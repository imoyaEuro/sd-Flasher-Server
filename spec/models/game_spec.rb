require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "creating a new Game with invalid url" do
    it "should fail" do
      begin
        game = FactoryGirl.create(Game,:name => "Portal",:description => "Portal is a 2007 first-person puzzle-platform video game developed by Valve Corporation.",
                                  :logo=> "asdfasdf")
      rescue
        game = nil
      end
      expect(game).to eq(nil)
    end
  end

end
