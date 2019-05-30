module ComplexFieldsBehavior

  private

  def is_complex?(attribute_name)
    complex_prefixes = [
      'complex',
      'instrument_function',
      'manufacturer',
      'managing_organization',
      'supplier',
      'manufacturer',
      'custom_property'
    ]
    complex_prefixes.each { |prefix| return true if attribute_name.to_s.start_with? prefix }
    false
  end

  def hash_is_blank?(hash_param)
    other_keys = hash_param.keys - ['id', '_destroy']
    return false unless other_keys.blank?
    if hash_param.fetch('id', nil) and hash_param.fetch('_destroy', nil)
      return false if hash_param['_destroy'] == "true"
    end
    true
  end

  def cleanup_params(attribute)
    if attribute.kind_of? Hash and attribute.keys.all? {|k| k !~ /\D/ }
      # removes hashes with integer keys
      attribute = cleanup_params(attribute.values)
    elsif attribute.kind_of? Hash
      new_attribute = {}
      attribute.each do |k, v|
        v = cleanup_params(v) if is_complex?(k)
        v = cleanup_params(v) if v.kind_of? Array
        unless v.blank?
          new_attribute[k] = v
        end
      end
      unless hash_is_blank?(new_attribute)
        new_attribute.compact
      else
        nil
      end
    elsif attribute.kind_of? Array
      new_attr = []
      attribute.reject(&:blank?).each do |v|
        v = cleanup_params(v) if v.kind_of? Hash
        new_attr << v unless v.blank?
      end
      new_attr.reject(&:blank?)
    elsif attribute.blank?
      nil
    else
      attribute
    end
  end
end
