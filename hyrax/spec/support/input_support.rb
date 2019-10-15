module InputSupport
  extend ActiveSupport::Concern
  include RSpec::Rails::HelperExampleGroup
end

RSpec.configure do |config|
  config.include InputSupport, type: :input
end
