module ComplexValidation
  extend ActiveSupport::Concern
  included do
    # affiliation_blank
    #   Requires job_title, organization
    resource_class.send(:define_method, :affiliation_blank) do |attributes|
      organization_blank = true
      Array(attributes[:complex_organization_attributes]).each do |org|
        organization_blank = organization_blank && Array(org[:organization]).all?(&:blank?)
      end
      Array(attributes[:job_title]).all?(&:blank?) || organization_blank
    end
    # date_blank
    #   Requires date
    resource_class.send(:define_method, :date_blank) do |attributes|
      Array(attributes[:date]).all?(&:blank?)
    end
    # history_blank
    #   Requires upstream or downsteam or event date or operator
    resource_class.send(:define_method, :history_blank) do |attributes|
      date_blank = true
      Array(attributes[:complex_event_date_attributes]).each do |dt|
        date_blank = date_blank && Array(dt[:date]).all?(&:blank?)
      end
      person_blank = true
      Array(attributes[:complex_operator_attributes]).each do |p|
        person_blank = person_blank &&
        Array(p[:first_name]).all?(&:blank?) &&
        Array(p[:last_name]).all?(&:blank?) &&
        Array(p[:name]).all?(&:blank?)
      end
      Array(attributes[:upstream]).all?(&:blank?) &&
      Array(attributes[:downstream]).all?(&:blank?) &&
      date_blank && person_blank
    end
    # identifier_blank
    #   Requires identifier
    resource_class.send(:define_method, :identifier_blank) do |attributes|
      Array(attributes[:identifier]).all?(&:blank?)
    end
    # identifier_description_blank
    #   Requires description, identifier
    resource_class.send(:define_method, :identifier_description_blank) do |attributes|
      identifiers_blank = true
      Array(attributes[:complex_identifier_attributes]).each do |id|
        identifiers_blank = identifiers_blank && Array(id[:identifier]).all?(&:blank?)
      end
      Array(attributes[:description]).all?(&:blank?) || identifiers_blank
    end
    # instrument_blank
    #   Requires date, identifier and person
    resource_class.send(:define_method, :instrument_blank) do |attributes|
      identifiers_blank = true
      Array(attributes[:complex_identifier_attributes]).each do |id|
        identifiers_blank = identifiers_blank && Array(id[:identifier]).all?(&:blank?)
      end
      date_blank = true
      Array(attributes[:complex_date_attributes]).each do |dt|
        date_blank = date_blank && Array(dt[:date]).all?(&:blank?)
      end
      person_blank = true
      Array(attributes[:complex_person_attributes]).each do |p|
        person_blank = person_blank &&
        Array(p[:first_name]).all?(&:blank?) &&
        Array(p[:last_name]).all?(&:blank?) &&
        Array(p[:name]).all?(&:blank?)
      end
      date_blank || identifiers_blank || person_blank
    end
    # key_value_blank
    #   Requires label and description
    resource_class.send(:define_method, :key_value_blank) do |attributes|
      Array(attributes[:label]).all?(&:blank?) ||
      Array(attributes[:description]).all?(&:blank?)
    end
    # organization_blank
    #   Requires organization
    resource_class.send(:define_method, :organization_blank) do |attributes|
      Array(attributes[:organization]).all?(&:blank?)
    end
    # person_blank
    #   Requires first name or last name or name
    resource_class.send(:define_method, :person_blank) do |attributes|
      (Array(attributes[:first_name]).all?(&:blank?) &&
      Array(attributes[:last_name]).all?(&:blank?) &&
      Array(attributes[:name]).all?(&:blank?))
    end
    # purchase_record_blank
    #   Requires title and date
    resource_class.send(:define_method, :purchase_record_blank) do |attributes|
      Array(attributes[:date]).all?(&:blank?) ||
      Array(attributes[:title]).all?(&:blank?)
    end
    # relation_blank
    #   Requires title / url / identifier and relationship
    resource_class.send(:define_method, :relation_blank) do |attributes|
      identifiers_blank = true
      Array(attributes[:complex_identifier_attributes]).each do |id|
        identifiers_blank = identifiers_blank && Array(id[:identifier]).all?(&:blank?)
      end
      (Array(attributes[:title]).all?(&:blank?) &&
      Array(attributes[:url]).all?(&:blank?) && identifiers_blank) ||
      Array(attributes[:relationship]).all?(&:blank?)
    end
    # rights_blank
    #   Requires rights
    resource_class.send(:define_method, :rights_blank) do |attributes|
      Array(attributes[:rights]).all?(&:blank?)
    end
    # specimen_type_blank
    #   Requires
    #     chemical_composition, crystallographic_structure, description,
    #     identifier, material_type, structural_feature and title
    resource_class.send(:define_method, :specimen_type_blank) do |attributes|
      # complex_chemical_composition blank
      cc_blank = true
      Array(attributes[:complex_chemical_composition_attributes]).each do |cc|
        cc_blank = cc_blank && Array(cc[:description]).all?(&:blank?)
      end
      # complex_crystallographic_structure blank
      cs_blank = true
      Array(attributes[:complex_crystallographic_structure_attributes]).each do |cs|
        cs_blank = cs_blank && Array(cs[:description]).all?(&:blank?)
      end
      # identifier blank
      id_blank = true
      Array(attributes[:complex_identifier_attributes]).each do |id|
        id_blank = id_blank && Array(id[:identifier]).all?(&:blank?)
      end
      # complex_material_type blank
      mt_blank = true
      Array(attributes[:complex_material_type_attributes]).each do |mt|
        mt_blank = mt_blank &&
                   Array(mt[:description]).all?(&:blank?) &&
                   Array(mt[:material_type]).all?(&:blank?) &&
                   Array(mt[:material_sub_type]).all?(&:blank?)
      end
      # complex_structural_feature blank
      sf_blank = true
      Array(attributes[:complex_structural_feature_attributes]).each do |sf|
        sf_blank = sf_blank &&
                   Array(sf[:description]).all?(&:blank?) &&
                   Array(sf[:category]).all?(&:blank?) &&
                   Array(sf[:sub_category]).all?(&:blank?)
      end
      cc_blank ||
      cs_blank ||
      Array(attributes[:description]).all?(&:blank?) ||
      id_blank ||
      mt_blank ||
      sf_blank ||
      Array(attributes[:title]).all?(&:blank?)
    end
    # version_blank
    #   Requires version
    resource_class.send(:define_method, :version_blank) do |attributes|
      Array(attributes[:version]).all?(&:blank?)
    end
    # event_blank
    #  Requires title
    resource_class.send(:define_method, :event_blank) do |attributes|
      Array(attributes[:title]).all?(&:blank?)
    end
  end
end
