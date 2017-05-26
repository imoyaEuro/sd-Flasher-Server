class ApiProvidersController < BaseApiController
  before_filter :authenticate_user_from_token!
  def me
    render json: @provider.serializable_hash.slice("id","name","email","credit")
  end
 end
