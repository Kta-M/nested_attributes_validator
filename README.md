#
# NestedAttributesValidator

Nested Attributes Validation Collection for Rails

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nested_attributes_validator'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nested_attributes_validator

## Usage

### nested_attributes_uniqueness
```ruby
# uniqueness validation for one field of child model
validates :children,
          nested_attributes_uniqueness: {
            fields: :field1,
            ignore_nil: true # the child record will be ignored if the field is nil.(default: false)
          }

# uniqueness validation for multiple fields of child model
validates :children,
          nested_attributes_uniqueness: {
			fields: [:field1, :field2],
            display_field: :field3,  # the error will be added to this field when the validation failed.
            ignore_nil: true # the child record will be ignored if all fields are nil.(default: false)
          }
```
### nested_attributes_order
```ruby
# order validation for one field of child model
validates :children,
          nested_attributes_order: {
            fields: :field1,
            ignore_nil: true, # the child record will be ignored if the field is nil.(default: false)
            condition: lambda{|a, b| a > b} # lambda function for order verification.(default: lambda{|a, b| a < b})
          }

# order validation for multiple fields of child model
validates :children,
          nested_attributes_order: {
			fields: [:field1, :field2],
            display_field: :field3,  # the error will be added to this field when the validation failed.
            ignore_nil: true, # the child record will be ignored if the all fields are nil.(default: false)
            condition: lambda{|a, b| a.join > b.join} # lambda function for order verification.(default: lambda{|a, b| a < b})
          }
```

### I18n
```yaml
en:
  errors:
    messages:
      nested_attributes_not_unique: "error message for not unique"
      nested_attributes_invalid_order: "error message for invalid order"
```

## Contributing

1. Fork it!
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).



