class SdPackage < ActiveRecord::Base
	belongs_to :provider
	has_many :sales
	private
end
