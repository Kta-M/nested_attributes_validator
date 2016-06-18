class NestedAttributesUniquenessValidator < ActiveModel::EachValidator

  def validate_each(record, _attribute, values)
    fields = ([options[:fields]] || [:self]).flatten.map(&:to_s)

    # detect duplicated values
    h = values.inject({}){|ret, v| ret[v] = fields.map{|f| v.send(f)}; ret}
    if options[:ignore_nil]
      h = h.reject{|_k, v| v.all?(&:nil?)}
    end
    duplicated_values = h.group_by{|_k ,v| v}.values.select{|a| a.size>1}.flatten(1).to_h.keys

    # set errors
    duplicated_values.each do |value|
      fields.each do |field|
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
