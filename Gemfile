source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '4.2.1'
gem 'pg'

gem 'uglifier', '>= 1.3.0'
gem 'therubyracer',  platforms: :ruby

gem 'devise'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'rest-client'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'rails_admin'
gem 'rails_admin_history_rollback'
#gem 'paper_trail', '~> 4.0.0' # already included via rails_admin_history_rollback
gem 'cancancan', '~> 1.10'
gem 'role_model'
group :development do
  gem 'railroady'
end
group :development, :test do
	gem 'rspec-rails'
	gem 'rspec-its'
	gem 'pry-rails'
	gem 'factory_girl_rails'
	gem 'faker'
	gem 'spring'
end

group :test do
	gem 'shoulda-matchers'
	gem 'database_cleaner'
	gem 'simplecov', :require => false
    gem 'json_spec'
end
