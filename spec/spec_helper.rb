require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nested_attributes_validator'

class TestModel
  include ActiveModel::Validations

  def initialize(attrs = {})
    attrs.each_pair {|k, v| send("#{k}=", v) }
  end
end
