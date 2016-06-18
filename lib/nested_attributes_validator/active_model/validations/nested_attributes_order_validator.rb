class NestedAttributesOrderValidator < ActiveModel::EachValidator
  include NestedAttributesValidatorUtil

  def validate_each(record, _attribute, values)
    trg_fields = target_fields

    trg_values = target_values(trg_fields, values)
    if trg_fields.size == 1
      trg_values.keys.each {|k| trg_values[k] = trg_values[k].first}
    end

    trg_values.each_cons(2) do |(v1, f1), (v2, f2)|
      condition = options[:condition] || lambda {|a, b| a < b}
      is_valid = condition.call(f1, f2)

      unless is_valid
        trg_fields.each do |field|
          # set error to the parent record
          attribute_name = :"#{attributes.first}.#{options[:display_field] || field}"
          record.errors[attribute_name] << I18n.t('errors.messages.nested_attributes_invalid_order')
          record.errors[attribute_name].uniq!

          # also set error to the child record to apply "field_with_errors"
          v1.errors.add(field , nil)
          v2.errors.add(field , nil)
        end
      end
    end
  end
end
