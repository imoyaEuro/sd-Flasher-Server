Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :providers
  get '/' => 'home#index'
  get '/not_admin' => 'not_admin#index'
  scope '/api' do
    scope '/v1' do
      scope '/games' do
        get '/' => 'api_games#index'
        scope '/:id' do
          post '/' => 'api_games#show'
        end
      end
      scope '/profile' do
        get '/' => 'api_providers#me'
      end
      scope '/sdpackage/' do
        scope '/tablet' do
          post '/' => 'api_sd_packages#tablet' 
        end
      end
      scope '/packages' do
        get '/' => 'api_packages#index'
        scope '/:id' do
          get '/' => 'api_packages#show'
          scope '/buy' do
            post '/' => 'api_packages#buy'
          end
        end
      end
    end
  end
end
