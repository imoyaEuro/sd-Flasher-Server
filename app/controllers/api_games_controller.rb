class ApiGamesController < BaseApiController
  before_filter :authenticate_user_from_token!, only: [:index]
  def index
    render json: Game.all.map{|f| {
      "id" => f.id,
      "name" => f.name,
      "version" => f.version,
      "version_description" => f.version_description,
      "description" => f.description,
      "short_description" => f.short_description,
      "company" => f.company,
      "apk_link" => f.apk_link,
      "logo" => f.logo,
      "images" => f.images } }
  end
  
  # Search the database for a SdPackage with that key and tablet.
  # If it is found, then it checks what packages was bought for that SdPackage.
  # Then it checks if the game requested belongs to that package.
  # If it does, it returns the gamekey.
  def show
    if params["key"].nil? && params["tablet"].nil?
      render json: {"error": 11, "message":"talbet id and SdPackage key missing"}, status: :bad_request 
      return
    end
    if params["key"].nil?
      render json: {"error": 5, "message": "SdPackage key missing"}, status: :bad_request
      return
    end
    if params["tablet"].nil?
      render json: {"error": 7, "message":"tablet id missing"}, status: :bad_request 
      return
    end
    sd_package = SdPackage.where(:key => params["key"]).where(:tablet => params["tablet"]).first
    game = Game.where(:id => params["id"]).first
    if game.nil?
      render json: {"error": 12, "message":"Game not found"}, status: :not_found
      return
    elsif sd_package.nil?
      render json: {"error": 10, "message":"Invalid key/tablet combination"}, status: :unauthorized
      return
    elsif !sd_package_has_that_game(sd_package,game)
      render json: {"error": 13, "message":"This SdPackage has a package which didn't include this game"}, status: :unauthorized
      return
    else
      render json: {"id": game.id, "name": game.name, "gamekey": game.gamekey}
    end

  end

  private
  def sd_package_has_that_game(sd_package,game)
    return false if sd_package.nil? || game.nil?
    sale=Sale.where(:sd_package_id => sd_package.id).first
    return false if sale.nil?
    game.packages.where(:id => sale.package_id).count > 0
  end
end
