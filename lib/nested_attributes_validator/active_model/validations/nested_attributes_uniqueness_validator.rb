class NestedAttributesUniquenessValidator < ActiveModel::EachValidator
  include NestedAttributesValidatorUtil

  def validate_each(record, _attribute, values)
    trg_fields = target_fields

    # detect duplicated values
    duplicated_values = target_values(trg_fields, values)
                          .group_by{|_k ,v| v}.values
                          .select{|a| a.size>1}
                          .flatten(1)
                          .to_h
                          .keys

    # set errors
    duplicated_values.each do |value|
      trg_fields.each do |field|
        # set error to the parent record
        attribute_name = :"#{attributes.first}.#{options[:display_field] || field}"
        record.errors[attribute_name] << I18n.t('errors.messages.nested_attributes_not_unique')
        record.errors[attribute_name].uniq!

        # also set error to the child record to apply "field_with_errors"
        value.errors.add(field , nil)
      end
    end
  end
end
