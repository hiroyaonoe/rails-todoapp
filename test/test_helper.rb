ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def log_in_as(id)
    cookies[:id] = id
  end
end
