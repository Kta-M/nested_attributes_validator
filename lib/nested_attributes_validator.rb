require 'active_model'
require "nested_attributes_validator/version"

%w(
  uniqueness order
).each do |type|
  require "nested_attributes_validator/active_model/validations/nested_attributes_#{type}_validator"
end
