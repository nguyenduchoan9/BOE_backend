DeviseTokenAuth.setup do |config|
  config.max_number_of_devices = 20
  config.change_headers_on_each_request = false
  config.token_lifespan = 2.weeks
  config.default_confirm_success_url = '/confirm'
  config.enable_standard_devise_support = false
  
  # By default sending current password is not needed for the password update.
  # Uncomment to enforce current_password param to be checked before all
  # attribute updates. Set it to :password if you want it to be checked only if
  # password is updated.
  # config.check_current_password_before_update = :attributes

end
