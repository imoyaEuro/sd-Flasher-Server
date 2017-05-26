class BaseApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  private
  def authenticate_user_from_token!
    @json = request.params
    if !@json['api_token']
      render json: {"error":3,"message":"api_token missing"}, status: :unauthorized
      return 
    else
      @provider = nil
      Provider.find_each do |u|
        if Devise.secure_compare(u.api_token, @json['api_token'])
          @provider = u
        end
      end
    end
    render json: {"error":4,"message":"unauthorized"}, status: :unauthorized if @provider.nil?

  end

end
