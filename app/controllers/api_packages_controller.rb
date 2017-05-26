class ApiPackagesController < BaseApiController
  before_filter :authenticate_user_from_token!
  before_filter :find_package, only: [:show, :buy]
  before_filter :key_presence, only: [:buy]
  before_filter :check_if_key_is_already_used, only: [:buy]
  
  def index
    render json: Package.all.select(:id,:name,:description,:price,:logo)
  end

  def show
    render json: { "package" => @package.serializable_hash.slice("id","name","description","price","logo"),
                   "games" => @package.games.map{|f| {
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
                   #@package.games.select(:id,:name,:version,:description,:images)
    }
  end

  def buy
    if (@provider.credit - @package.price) >= 0
      @provider.credit-=@package.price
      @provider.save
      @sd_package = SdPackage.create(:key => params[:key], 
                                     :provider_id => @provider.id);
      Sale.create(:provider_id => @provider.id, 
                  :package_id => @package.id, 
                  :price => @package.price, 
                  :sd_package_id => @sd_package.id, 
                  :ip => request.env['REMOTE_ADDR'])
      render json: {"status":"ok"}
    else
      render json: {"error": 1, "message":"Not enough credits"}
    end
  end

  private
  def find_package
    begin
      @package = Package.find(params[:id])
    rescue
      render json:  {"error":2,"message":"Package not found"}, status: :not_found if @package.nil?
    end
  end

  def key_presence
    if params[:key].nil?
      render json: {"error":5,"message":"SdPackage key missing"}, status: :bad_request
    end
  end

  def check_if_key_is_already_used
    @sd_package_count = SdPackage.where(:key => params[:key]).count
    render json: {"error":9,"message":"SdPackage key already in use"} if @sd_package_count!=0
  end
end
