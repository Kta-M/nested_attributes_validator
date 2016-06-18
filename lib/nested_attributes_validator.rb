require 'active_model'
require "nested_attributes_validator/version"
require "nested_attributes_validator/nested_attributes_validator_util"

%w(
  uniqueness order
).each do |type|
  require "nested_attributes_validator/active_model/validations/nested_attributes_#{type}_validator"
end
