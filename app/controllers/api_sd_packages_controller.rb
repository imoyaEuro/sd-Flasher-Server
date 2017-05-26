class ApiSdPackagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :key_presence, only: [:tablet]
  before_filter :tablet_presence, only: [:tablet]
  before_filter :find_sd_package, only: [:tablet]

  #
  # Checks if the tablet id sent
  # is associated with an SdPackage
  #
  def tablet
    if @sd_package.tablet == params[:tablet]
      #i assume it will always be a sale record associated
      tmp_games = @sd_package.sales.first.package.games
      render json: {"games" => tmp_games.map{|k| {
        "id" => k.id,
        "gamekey" => k.gamekey } } }
    elsif @sd_package.tablet.nil? || @sd_package.tablet.empty?
      @sd_package.tablet = params[:tablet]
      @sd_package.save
      #i assume it will always be a sale record associated
      tmp_games = @sd_package.sales.first.package.games
      render json: {"games" => tmp_games.map{|k| {
        "id" => k.id,
        "gamekey" => k.gamekey } } }
    else
      render json: {"error":8, "message":"Tablet id does not correspond to the one assigned to this SdPackage"}
    end
  end

  private
  def find_sd_package
      @sd_package = SdPackage.where(:key => params[:key]).first
      render json:  {"error":6,"message":"SdPackage not found"}, status: :not_found if @sd_package.nil?
  end

  def key_presence
    if params[:key].nil?
      render json: {"error":5,"message":"SdPackage key missing"}, status: :bad_request
    end
  end

  def tablet_presence
    if params[:tablet].nil?
      render json: {"error":7,"message":"Tablet id missing"}, status: :bad_request
    end
  end

end
