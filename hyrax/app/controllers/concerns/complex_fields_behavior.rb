module ComplexFieldsBehavior
  private

  def is_complex?(attribute_name)
    # Renamed managing_organization to managing_organization_attributes
    #  as managing_organization appears in dataset and is not complex
    complex_prefixes = %w[
      complex
      instrument_function
      manufacturer
      supplier
      custom_property
      managing_organization_attributes
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

  def value_is_blank?(val)
    return true if val.blank?
    if val.is_a? Array
      val.each do |v|
        return false unless v.blank?
      end
      return true
    end
    return false
  end

  def add_scrub_text(hash_param)
    # The active triple resource does not get deleted if all the fields except id and destroy are blank. 
    # So add dummy text to force a delete
    scrub_keys = %w[
      name
      title
      organization
      material_type
      job_title
      upstream
      description
      identifier
      rights
    ]
    scrub_keys.each do |key| 
      if hash_param.include?(key)
        if hash_param[key].is_a? Array
          hash_param[key] = ['Dummy text']
        else
          hash_param[key] = 'Dummy text'
        end
        return hash_param
      end
    end
    return hash_param
  end

  def delete_empty_hash(new_attribute)
    if new_attribute.keys.include?("_destroy")
      if new_attribute.fetch('id', nil).blank?
        # Remove empty hashes so it doesn't get added to the graph with an id
        new_attribute = {}
      else
        # For existing records that have been added with just an id (an empty triple otherwise),
        #   we need to add in a dummy text to one of the fields, so the triple gets deleted and not 
        #   ignored by the actor because it's an empty hash (other than id and _delete).
        new_attribute["_destroy"] = "true"
        new_attribute = add_scrub_text(new_attribute)
      end
    end
    new_attribute
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
          if complex_purchase_record['manufacturer_attributes'].present?
            complex_purchase_record['manufacturer_attributes'].each_with_index do |manufacturer, ii|
              if manufacturer['organization'].blank? && manufacturer['purpose'].include?('Manufacturer')
                attribute['complex_specimen_type_attributes'][index]['complex_purchase_record_attributes'][i]['manufacturer_attributes'].delete_at(ii)
              end
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
      has_values = false
      attribute.each do |k, v|
        v = cleanup_params(v) if is_complex?(k)
        v = cleanup_params(v) if v.is_a? Array

        next if k == "find_child_work"
        # Instead of skipping blanks, force them to empty strings so dirty tracking works
        #   This is to enable a user to remove entries from a field.
        #   Setting it to nil or empty array, will not remove the active record triple
        if v.blank? && v.is_a?(Array)
          v = [''] unless k.end_with?('_attributes')
        elsif v.blank?
          v = ''
        end

        if skip_controlled.include?(k) || k.end_with?('_attributes')
          new_attribute[k] = v
        else
          val = sanitize_value(v)
          new_attribute[k] = val
          has_values = true unless value_is_blank?(val)
        end
      end
      new_attribute = delete_empty_hash(new_attribute) unless has_values 
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
      invitation_status
      contact_person
      display_order
      scheme
    ]
  end
end
