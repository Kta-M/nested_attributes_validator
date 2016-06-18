module NestedAttributesValidatorUtil

  def target_fields
    ([options[:fields]] || [:self]).flatten.map(&:to_s)
  end

  def target_values(fields, values)
    trg = values.inject({}) do |ret, v|
      ret[v] = fields.map{|f| v.send(f)}
      ret
    end
    if options[:ignore_nil]
      trg = trg.reject{|_k, v| v.all?(&:nil?)}
    end
    trg
  end

end
