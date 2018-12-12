module ComplexAttributes
  extend ActiveSupport::Concern
  included do
    # date_blank
    #   Requires date
    resource_class.send(:define_method, :date_blank) do |attributes|
      Array(attributes[:date]).all?(&:blank?)
    end
    # identifier_blank
    #   Requires identifier
    resource_class.send(:define_method, :identifier_blank) do |attributes|
      Array(attributes[:identifier]).all?(&:blank?)
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
    #   Requires label / url / identifier and
    #            relationship name / relationship role
    resource_class.send(:define_method, :relation_blank) do |attributes|
      identifiers_blank = true
      Array(attributes[:complex_identifier_attributes]).each do |id|
        identifiers_blank = identifiers_blank && Array(id[:identifier]).all?(&:blank?)
      end
      (Array(attributes[:label]).all?(&:blank?) &&
      Array(attributes[:url]).all?(&:blank?) && identifiers_blank) ||
      (Array(attributes[:relationship_role]).all?(&:blank?) &&
      Array(attributes[:relationship_name]).all?(&:blank?))
    end
    # rights_blank
    #   Requires version
    resource_class.send(:define_method, :rights_blank) do |attributes|
      Array(attributes[:rights]).all?(&:blank?)
    end
    # specimen_type_blank
    #   Requires title and date
    resource_class.send(:define_method, :specimen_type_blank) do |attributes|
      identifiers_blank = true
      Array(attributes[:complex_identifier_attributes]).each do |id|
        identifiers_blank = identifiers_blank && Array(id[:identifier]).all?(&:blank?)
      end
      Array(attributes[:chemical_composition]).all?(&:blank?) ||
      Array(attributes[:crystalograpic_structure]).all?(&:blank?) ||
      Array(attributes[:description]).all?(&:blank?) ||
      identifiers_blank ||
      Array(attributes[:material_types]).all?(&:blank?) ||
      Array(attributes[:structural_features]).all?(&:blank?) ||
      Array(attributes[:title]).all?(&:blank?)
    end
    # version_blank
    #   Requires version
    resource_class.send(:define_method, :version_blank) do |attributes|
      Array(attributes[:version]).all?(&:blank?)
    end
  end
end
