# frozen_string_literal: true

module ComplexRequirements
  extend ActiveSupport::Concern

  class_methods do
    def requirements_for(complex_property)
      model_requirements_for(complex_property) ||
        default_requirements_for(complex_property) ||
        {}
    end

    def default_requirements_for(complex_property)
      requirements[:nims][:default][complex_property]
    end

    def model_requirements_for(complex_property)
      return unless requirements[:nims][name.underscore.to_sym]
      requirements[:nims][name.underscore.to_sym][complex_property]
    end

    def requirements
      @requirements ||= validated_yaml(yaml)
    end

    def yaml
      YAML.safe_load(
        ERB.new(
          File.read(Rails.root.join('config', 'nims_metadata_requirements.yml'))
        ).result
      )
    end

    # @todo add some basic validation for the YAML
    #   restrict what can be controlled this way, ie complex resources only
    #   check for arrays etc.
    def validated_yaml(yaml)
      yaml.deep_symbolize_keys!
    end
  end
end
