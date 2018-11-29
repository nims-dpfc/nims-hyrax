module ComplexAttributes
  extend ActiveSupport::Concern
  included do
    # relation_blank
    # Need label / url / identifier and
    #      relationship name / relationship role
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
    # creator_blank
    # Need first name or last name or name
    resource_class.send(:define_method, :person_blank) do |attributes|
      (Array(attributes[:first_name]).all?(&:blank?) &&
      Array(attributes[:last_name]).all?(&:blank?) &&
      Array(attributes[:name]).all?(&:blank?))
    end
    # identifier_blank
    # Need identifier
    resource_class.send(:define_method, :identifier_blank) do |attributes|
      Array(attributes[:identifier]).all?(&:blank?)
    end
    # date_blank
    # Need date
    resource_class.send(:define_method, :date_blank) do |attributes|
      Array(attributes[:date]).all?(&:blank?)
    end
  end
end
