module ComplexFieldsBehavior
  private

  def is_complex?(attribute_name)
    complex_prefixes = %w[
      complex
      instrument_function
      manufacturer
      managing_organization
      supplier
      manufacturer
      custom_property
    ]
    complex_prefixes.each { |prefix| return true if attribute_name.to_s.start_with? prefix }
    false
  end

  def hash_is_blank?(hash_param)
    other_keys = hash_param.keys - %w[id _destroy]
    return false unless other_keys.blank?
    if hash_param.fetch('id', nil) && hash_param.fetch('_destroy', nil)
      return false if ['true', '1', true, 1].include? hash_param['_destroy']
    end
    true
  end

  # Delete person/organization from instrument and specimen_type where the record contains
  #   only role=operator (person) or purpose=manufacturer/supplier (organization)
  #   this happens because we are validating nothing on instrument or speciment_type
  # This is temporary until proper validation is in place
  def cleanup_instrument_and_specimen_type(attribute)
    # complex_instrument
    attribute['complex_instrument_attributes'].each_with_index do |complex_instrument, index|
      if complex_instrument['complex_person_attributes'].present?
        complex_instrument['complex_person_attributes'].each_with_index do |complex_person, i|
          if complex_person['name'].blank? && complex_person['role'].include?('operator')
            attribute['complex_instrument_attributes'][index]['complex_person_attributes'].delete_at(i)
          end
        end
      end
      if complex_instrument['manufacturer_attributes'].present?
        complex_instrument['manufacturer_attributes'].each_with_index do |manufacturer, i|
          if manufacturer['organization'].blank? && manufacturer['purpose'].include?('Manufacturer')
            attribute['complex_instrument_attributes'][index]['manufacturer_attributes'].delete_at(i)
          end
        end
      end
      if complex_instrument['managing_organization_attributes'].present?
        complex_instrument['managing_organization_attributes'].each_with_index do |managing_organization, i|
          if managing_organization['organization'].blank? && managing_organization['purpose'].include?('Managing organization')
            attribute['complex_instrument_attributes'][index]['managing_organization_attributes'].delete_at(i)
          end
        end
      end
      if complex_instrument['complex_date_attributes'].present?
        complex_instrument['complex_date_attributes'].each_with_index do |complex_date, i|
          if complex_date.present?
            if complex_date['date'].blank? && complex_date['description'].include?('Processed')
              attribute['complex_instrument_attributes'][index]['complex_date_attributes'].delete_at(i)
            end
          end
        end
      end
    end
    # complex_specimen_type
    attribute['complex_specimen_type_attributes'].each_with_index do |complex_specimen_type, index|
      if complex_specimen_type['complex_purchase_record_attributes'].present?
        complex_specimen_type['complex_purchase_record_attributes'].each_with_index do |complex_purchase_record, i|
          if complex_purchase_record['supplier_attributes'].present?
            complex_purchase_record['supplier_attributes'].each_with_index do |supplier, ii|
              if supplier['organization'].blank? && supplier['purpose'].include?('Supplier')
                attribute['complex_specimen_type_attributes'][index]['complex_purchase_record_attributes'][i]['supplier_attributes'].delete_at(ii)
              end
            end
          end
          complex_purchase_record['manufacturer_attributes'].each_with_index do |manufacturer, ii|
            if manufacturer['organization'].blank? && manufacturer['purpose'].include?('Manufacturer')
              attribute['complex_specimen_type_attributes'][index]['complex_purchase_record_attributes'][i]['manufacturer_attributes'].delete_at(ii)
            end
          end
        end
      end
    end
    attribute
  end

  def cleanup_params(attribute)
    if attribute.is_a?(Hash) && attribute.keys.all? { |k| k !~ /\D/ }
      # removes hashes with integer keys
      cleanup_params(attribute.values)
    elsif attribute.is_a? Hash
      new_attribute = {}
      attribute.each do |k, v|
        v = cleanup_params(v) if is_complex?(k)
        v = cleanup_params(v) if v.is_a? Array
        next if v.blank?
        new_attribute[k] = if skip_controlled.include?(k) || k.end_with?('_attributes')
                             v
                           else
                             sanitize_value(v)
                           end
      end
      new_attribute.compact unless hash_is_blank?(new_attribute)
    elsif attribute.is_a? Array
      new_attr = []
      attribute.reject(&:blank?).each do |v|
        v = cleanup_params(v) if v.is_a? Hash
        new_attr << sanitize_value(v) unless v.blank?
      end
      new_attr.reject(&:blank?)
    elsif attribute.blank?
      nil
    else
      attribute
    end
  end

  def sanitize_value(value)
    if value.is_a? Array
      value.map do |v|
        if v.is_a? String
          Loofah.fragment(v).scrub!(:escape).to_s
        else
          v
        end
      end
    elsif value.is_a? String
      Loofah.fragment(value).scrub!(:escape).to_s
    else
      value
    end
  end

  # Don't scrub controlled fields
  def skip_controlled
    %w[
      representative_id
      thumbnail_id
      visibility_during_embargo
      visibility_after_embargo
      visibility_during_lease
      visibility_after_lease
      visibility
      admin_set_id
      data_origin
      version
      _destroy
      id
      purpose
      role
    ]
  end
end
