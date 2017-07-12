source 'https://rubygems.org'


gem 'rails', '~> 5.0.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem 'coffee-rails', '~> 4.2'
gem 'coffee-script-source', '1.8.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 3.0'
gem "breadcrumbs_on_rails"
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git', :require => 'bcrypt'
gem 'active_model_serializers', '~> 0.10.0' # json response as collection
gem 'materialize-sass'
gem 'faker' # fake data
gem 'activerecord-import' # bulk insert record
gem 'annotate' # annotate model
gem "chartkick" #chart
gem 'devise_token_auth', '~> 0.1.39' # authen-token
gem 'devise', '~> 4.2.0' # authen
gem 'omniauth-facebook' # authen fb/github/..
gem 'gcm'
gem 'groupdate'
gem 'carrierwave', '>= 1.0.0.rc', '< 2.0' # File Uploader
gem 'mini_magick' # resize picture
gem 'fog' # aws
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
gem 'kaminari' # paginate model view
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-materialize', '0.1.2'
# gem 'geocoder' # longtitue, ip address , city, hometown
gem 'rack-cors', :require => 'rack/cors' # cross origin region
gem "figaro" # ENV
gem "sidekiq"
gem 'rqrcode', '~> 0.10.1' #qr code
gem 'chunky_png' #save image
gem 'jquery-ui-rails'
gem 'firebase'
gem 'fcm'
gem 'braintree'
gem 'paypal-sdk-rest'
gem 'httparty'
# gem 'fb_graph2'
gem 'fb_graph'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
end

group :test do
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
