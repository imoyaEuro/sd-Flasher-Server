class Sale < ActiveRecord::Base
	belongs_to :package
	belongs_to :sd_package
	belongs_to :provider
  validates :price, presence: :true
  validates :ip, presence: true
end
