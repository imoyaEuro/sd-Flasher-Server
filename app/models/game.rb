class Game < ActiveRecord::Base
  require 'uri'
  validates_each :logo, :image1, :image2, :image3, :image4, :image5, :image6, :image7, :image8, :image9, :image10, allow_blank: true do |record, attr, value|
    record.errors.add attr, 'non-valid URL' if !valid_url?(value) && !value.nil?
  end

  has_and_belongs_to_many :packages
  validates :name, presence: :true

  def images
    [image1,image2,image3,image4,image5,image6,image7,image8,image9,image10].compact.reject(&:blank?)
  end


  private
  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end


end
