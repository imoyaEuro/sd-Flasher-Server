class Provider < ActiveRecord::Base
  has_paper_trail :only => [:credit]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :sd_packages
  has_many :sales
  after_create :generate_api_token
  private
  
  def generate_api_token
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    self.api_token = (0...64).map { o[rand(o.length)] }.join
    self.save
  end
end
