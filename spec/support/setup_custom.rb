require 'rspec/expectations'
Dir[Rails.root.join('spec/support/matchers/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/helpers/*.rb')].each { |f| require f }

# module CustomMatcher
#   include Matchers::ValidateIndexMatcher
#   include Matchers::ValidateEmailFormatMatcher
#   include Matchers::HasDefaultValue
# end

module CustomHelper
  include Helpers::Json
  include Helpers::Authen
end
