module ComplexValidation
  extend ActiveSupport::Concern
  included do
    # nested_to_array
    resource_class.send(:define_method, :nested_to_array) do |attributes, key|
      vals = attributes.fetch(key, [])
      vals = [vals] unless vals.kind_of? Array
      vals
    end

    # get_val_blank
    resource_class.send(:define_method, :get_val_blank) do |attributes, key|
      vals = nested_to_array(attributes, key)
      vals.all?(&:blank?)
    end

    # get_org_blank
    resource_class.send(:define_method, :get_org_blank) do |attributes, key|
      organization_blank = true
      return true if attributes.blank?
      orgs = nested_to_array(attributes, key)
      puts orgs
      orgs.each do |org|
        vals = nested_to_array(org, :organization)
        organization_blank = organization_blank && vals.all?(&:blank?)
      end
      organization_blank
    end

    # get_dt_blank
    resource_class.send(:define_method, :get_dt_blank) do |attributes, key|
      date_blank = true
      dates = nested_to_array(attributes, key)
      dates.each do |dt|
        vals = nested_to_array(dt, :date)
        date_blank = date_blank && vals.all?(&:blank?)
      end
      date_blank
    end

    # get_people_blank
    resource_class.send(:define_method, :get_people_blank) do |attributes, key|
      people_blank = true
      people = nested_to_array(attributes, key)
      people.each do |p|
        first_name = nested_to_array(p, :first_name)
        last_name = nested_to_array(p, :last_name)
        nam = nested_to_array(p, :name)
        people_blank = people_blank &&
        first_name.all?(&:blank?) &&
        last_name.all?(&:blank?) &&
        nam.all?(&:blank?)
      end
      people_blank
    end

    # get_id_blank
    resource_class.send(:define_method, :get_id_blank) do |attributes, key|
      identifiers_blank = true
      identifiers = nested_to_array(attributes, key)
      identifiers.each do |id|
        ids = nested_to_array(id, :identifier)
        identifiers_blank = identifiers_blank && ids.all?(&:blank?)
      end
      identifiers_blank
    end

    # affiliation_blank
    #   Requires job_title, organization
    resource_class.send(:define_method, :affiliation_blank) do |attributes|
      return true if attributes.blank?
      organization_blank = get_org_blank(attributes, :complex_organization_attributes)
      job_title_blank = get_val_blank(attributes, :job_title)
      job_title_blank || organization_blank
    end
    # date_blank
    #   Requires date
    resource_class.send(:define_method, :date_blank) do |attributes|
      return true if attributes.blank?
      get_val_blank(attributes, :date)
    end
    # history_blank
    #   Requires upstream or downsteam or event date or operator
    resource_class.send(:define_method, :history_blank) do |attributes|
      return true if attributes.blank?
      date_blank = get_dt_blank(attributes, :complex_event_date_attributes)
      person_blank = get_people_blank(attributes, :complex_operator_attributes)
      up_blank = get_val_blank(attributes, :upstream)
      down_blank = get_val_blank(attributes, :downstream)
      up_blank && down_blank && date_blank && person_blank
    end
    # identifier_blank
    #   Requires identifier
    resource_class.send(:define_method, :identifier_blank) do |attributes|
      return true if attributes.blank?
      get_val_blank(attributes, :identifier)
    end
    # identifier_description_blank
    #   Requires description, identifier
    resource_class.send(:define_method, :identifier_description_blank) do |attributes|
      return true if attributes.blank?
      identifiers_blank = get_id_blank(attributes, :complex_identifier_attributes)
      desc_blank = get_val_blank(attributes, :description)
      desc_blank || identifiers_blank
    end
    # instrument_blank
    #   Requires date, identifier and person
    #   27/8/2019 - temporarily remove required fields (#162)     31/1/2020 - reinstate required fields (#218)
    resource_class.send(:define_method, :instrument_blank) do |attributes|
      return true if attributes.blank?
      identifiers_blank = get_id_blank(attributes, :complex_identifier_attributes)
      date_blank = get_dt_blank(attributes, :complex_date_attributes)
      person_blank = get_people_blank(attributes, :complex_person_attributes)
      date_blank || identifiers_blank || person_blank
    end
    # key_value_blank
    #   Requires label and description
    resource_class.send(:define_method, :key_value_blank) do |attributes|
      return true if attributes.blank?
      label_blank = get_val_blank(attributes, :label)
      desc_blank = get_val_blank(attributes, :description)
      label_blank || desc_blank
    end
    # organization_blank
    #   Requires organization
    resource_class.send(:define_method, :organization_blank) do |attributes|
      return true if attributes.blank?
      get_val_blank(attributes, :organization)
    end
    # person_blank
    #   Requires first name or last name or name
    resource_class.send(:define_method, :person_blank) do |attributes|
      return true if attributes.blank?
      first_name_blank = get_val_blank(attributes, :first_name)
      last_name_blank = get_val_blank(attributes, :last_name)
      name_blank = get_val_blank(attributes, :name)
      first_name_blank && last_name_blank && name_blank
    end
    # purchase_record_blank
    #   Requires title and date
    resource_class.send(:define_method, :purchase_record_blank) do |attributes|
      return true if attributes.blank?
      date_blank = get_val_blank(attributes, :date)
      title_blank = get_val_blank(attributes, :title)
      date_blank || title_blank
    end
    # relation_blank
    #   Requires title / url / identifier and relationship
    resource_class.send(:define_method, :relation_blank) do |attributes|
      return true if attributes.blank?
      identifiers_blank = get_id_blank(attributes, :complex_identifier_attributes)
      title_blank = get_val_blank(attributes, :title)
      url_blank = get_val_blank(attributes, :url)
      rel_blank = get_val_blank(attributes, :relationship)
      (title_blank && url_blank && identifiers_blank) || rel_blank
    end
    # rights_blank
    #   Requires rights
    resource_class.send(:define_method, :rights_blank) do |attributes|
      return true if attributes.blank?
      get_val_blank(attributes, :rights)
    end
    # specimen_type_blank
    #   Requires
    #     chemical_composition, crystallographic_structure, description,
    #     identifier, material_type, structural_feature and title
    #   27/8/2019 - temporarily remove required fields (#162)   31/1/2020 - reinstate required fields (#218)
    resource_class.send(:define_method, :specimen_type_blank) do |attributes|
      return true if attributes.blank?
      # complex_chemical_composition blank
      cc_blank = true
      nested_to_array(attributes, :complex_chemical_composition_attributes).each do |cc|
        cc_blank = cc_blank && get_val_blank(cc, :description)
      end
      # complex_crystallographic_structure blank
      cs_blank = true
      nested_to_array(attributes, :complex_crystallographic_structure_attributes).each do |cs|
        cs_blank = cs_blank && get_val_blank(cs, :description)
      end
      # identifier blank
      id_blank = get_id_blank(attributes, :complex_identifier_attributes)
      # complex_material_type blank
      mt_blank = true
      nested_to_array(attributes, :complex_material_type_attributes).each do |mt|
        mt_blank = mt_blank &&
                   get_val_blank(mt, :description) &&
                   get_val_blank(mt, :material_type) &&
                   get_val_blank(mt, :material_sub_type)
      end
      # complex_structural_feature blank
      sf_blank = true
      Array(attributes[:complex_structural_feature_attributes]).each do |sf|
        sf_blank = sf_blank &&
                   get_val_blank(sf, :description) &&
                   get_val_blank(sf, :category) &&
                   get_val_blank(sf, :sub_category)
      end
      # description blank
      desc_blank = get_val_blank(attributes, :description)
      # title blank
      title_blank = get_val_blank(attributes, :title)
      # combine them all
      cc_blank ||
      cs_blank ||
      desc_blank ||
      id_blank ||
      mt_blank ||
      sf_blank ||
      title_blank
    end
    # version_blank
    #   Requires version
    resource_class.send(:define_method, :version_blank) do |attributes|
      return true if attributes.blank?
      get_val_blank(attributes, :version)
    end
    # event_blank
    #  Requires title
    resource_class.send(:define_method, :event_blank) do |attributes|
      return true if attributes.blank?
      get_val_blank(attributes, :title)
    end
  end
end
