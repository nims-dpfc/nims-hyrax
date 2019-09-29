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

  # Delete person/organization from instrument and specimen_type where the record contains 
  #   only role=operator (person) or purpose=manufacturer/supplier (organization)
  #   this happens because we are validating nothing on instrument or speciment_type
  # This is temporary until proper validation is in place
  def cleanup_instrument_and_specimen_type(attribute)
    require 'pry'
    binding.pry
    # complex_instrument
    attribute['complex_instrument_attributes'].each_with_index do | complex_instrument, index |
      complex_instrument['complex_person_attributes'].each_with_index do | complex_person, i |
        if complex_person['name'].blank? && complex_person['role'].include?('operator')
          attribute['complex_instrument_attributes'][index]['complex_person_attributes'].delete_at(i)
        end
      end
      complex_instrument['manufacturer_attributes'].each_with_index do | manufacturer, i |
        if manufacturer['organization'].blank? && manufacturer['purpose'].include?('Manufacturer')
          attribute['complex_instrument_attributes'][index]['manufacturer_attributes'].delete_at(i)
        end
      end
      complex_instrument['managing_organization_attributes'].each_with_index do | managing_organization, i |
        if managing_organization['organization'].blank? && managing_organization['purpose'].include?('Managing organization')
          attribute['complex_instrument_attributes'][index]['managing_organization_attributes'].delete_at(i)
        end
      end
    end
    # complex_specimen_type
    attribute['complex_specimen_type_attributes'].each_with_index do | complex_specimen_type, index |
      complex_specimen_type['complex_purchase_record_attributes'].each_with_index do | complex_purchase_record, i |
        complex_purchase_record['supplier_attributes'].each_with_index do | supplier, ii |
          if supplier['organization'].blank? && supplier['purpose'].include?('Supplier')
            attribute['complex_specimen_type_attributes'][index]['complex_purchase_record_attributes'][i]['supplier_attributes'].delete_at(ii)
          end
        end
        complex_purchase_record['manufacturer_attributes'].each_with_index do | manufacturer, ii |
          if manufacturer['organization'].blank? && manufacturer['purpose'].include?('Manufacturer')
            attribute['complex_specimen_type_attributes'][index]['complex_purchase_record_attributes'][i]['manufacturer_attributes'].delete_at(ii)
          end
        end
      end
    end
    attribute
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
