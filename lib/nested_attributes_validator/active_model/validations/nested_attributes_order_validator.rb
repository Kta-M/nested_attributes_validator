class NestedAttributesOrderValidator < ActiveModel::EachValidator

  def validate_each(record, _attribute, values)
    fields = ([options[:fields]] || [:self]).flatten.map(&:to_s)

    h = values.inject({}){|ret, v| ret[v] = fields.map{|f| v.send(f)}; ret}
    if options[:ignore_nil]
      h = h.reject{|_k, v| v.all?(&:nil?)}
    end
    if fields.size == 1
      h.keys.each {|k| h[k] = h[k].first}
    end

    h.each_cons(2) do |(v1, f1), (v2, f2)|
      condition = options[:condition] || lambda {|a, b| a < b}
      is_valid = condition.call(f1, f2)

      unless is_valid
        fields.each do |field|
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
