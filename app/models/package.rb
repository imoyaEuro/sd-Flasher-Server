class Package < ActiveRecord::Base
  validates_each :logo, allow_blank: false do |record, attr, value|
    record.errors.add attr, 'non-valid URL' if !valid_url?(value) && !value.nil?
  end
  has_and_belongs_to_many :games
  has_many :sales
  validates :name, presence: :true
  private
  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end
end
