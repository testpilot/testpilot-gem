$: << 'lib'
require "test_pilot"

Dir[File.expand_path("../support/*.rb", __FILE__)].each { |file| require file }

RSpec.configure do |config|
  config.mock_with :rspec
end
