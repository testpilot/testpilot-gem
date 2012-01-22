$stdin = File.new("/dev/null")

require "rubygems"
require "bundler/setup"

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "rspec"
require "fakefs/safe"
require 'tmpdir'
require "webmock/rspec"

require "test_pilot"

Dir[File.expand_path("../support/*.rb", __FILE__)].each { |file| require file }

require "test_pilot/helpers"
module TestPilot::Helpers
  undef_method :home_directory
  def home_directory
    @home_directory ||= Dir.mktmpdir
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
end
