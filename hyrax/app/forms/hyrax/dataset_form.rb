# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  # Generated form for Dataset
  class DatasetForm < Hyrax::Forms::WorkForm
    self.model_class = ::Dataset

    self.terms -= [
      # Fields not interested in
      :based_near, :contributor, :creator, :date_created, :identifier, :license,
      :related_url, :source,
      # Fields interested in, but removing to re-order
      :title, :description, :keyword, :language, :publisher, :resource_type,
      :rights_statement, :subject
      # Fields that are not displayed
      # :import_url, :date_modified, :date_uploaded, :depositor, :bibliographic_citation,
      # :date_created, :label, :relative_path
    ]

    self.terms += [
      # Adding all fields in order of display in form
      :title, :alternative_title, :description, :keyword, :language,
      :publisher, :resource_type, :complex_rights, :rights_statement, :subject,
      :complex_date, :complex_identifier, :complex_person, :complex_version,
      :characterization_methods, :computational_methods, :data_origin,
      # :instrument, # requires fields with 2nd level of nesting
      :origin_system_provenance, :properties_addressed,
      :complex_relation,
      :specimen_set, :specimen_type, :synthesis_and_processing, :custom_property
    ]

    self.required_fields -= [
      # Fields not interested in
      :creator, :keyword,
      # Fields interested in, but removing to re-order
      :title, :rights_statement]

    self.required_fields += [
      # # Adding all required fields in order of display in form
      :title, :data_origin, :specimen_set
    ]

    NESTED_ASSOCIATIONS = [:complex_date, :complex_identifier, :instrument,
      :complex_person, :complex_relation, :complex_rights, :specimen_type,
      :complex_version, :custom_property].freeze

    protected

    def self.permitted_date_params
      [:id,
       :_destroy,
       {
         date: [],
         description: []
       }
      ]
    end

    def self.permitted_identifier_params
      [:id,
       :_destroy,
       {
         identifier: [],
         scheme: [],
         label: []
       }
      ]
    end

    def self.permitted_instrument_params
      [:id,
       :_destroy,
       {
         alternative_title: [],
         complex_date_attributes: permitted_date_params,
         description: [],
         complex_identifier_attributes: permitted_identifier_params,
         function_1: [],
         function_2: [],
         manufacturer: [],
         complex_person_attributes: permitted_person_params,
         organization: [],
         title: []
       }
      ]
    end

    def self.permitted_person_params
      [:id,
       :_destroy,
       {
         name: [],
         role: [],
         affiliation: [],
         complex_identifier_attributes: permitted_identifier_params,
         uri: []
       }
      ]
    end

    def self.permitted_relation_params
      [:id,
       :_destroy,
       {
         title: [],
         url: [],
         complex_identifier_attributes: permitted_identifier_params,
         relationship: []
       }
      ]
    end

    def self.permitted_rights_params
      [:id,
       :_destroy,
       {
         date: [],
         rights: []
       }
      ]
    end

    def self.permitted_specimen_type_params
      [:id,
       :_destroy,
       {
         chemical_composition: [],
         crystallographic_structure: [],
         description: [],
         complex_identifier_attributes: permitted_identifier_params,
         material_types: [],
         purchase_record_attributes: permitted_purchase_record_params,
         complex_relation_attributes: permitted_relation_params,
         structural_features: [],
         title: []
       }
      ]
    end

    def self.permitted_version_params
      [:id,
       :_destroy,
       {
         date: [],
         description: [],
         identifier: [],
         version: []
       }
      ]
    end

    def self.permitted_custom_property_params
      [:id,
       :_destroy,
       {
         label: [],
         description: []
       }
      ]
    end

    def self.permitted_purchase_record_params
      [:id,
       :_destroy,
       {
         date: [],
         identifier: [],
         purchase_record_item: [],
         title: []
       }
      ]
    end

    def self.build_permitted_params
      permitted = super
      permitted << { complex_date_attributes: permitted_date_params }
      permitted << { complex_identifier_attributes: permitted_identifier_params }
      permitted << { instrument_attributes: permitted_instrument_params }
      permitted << { complex_person_attributes: permitted_person_params }
      permitted << { complex_relation_attributes: permitted_relation_params }
      permitted << { complex_rights_attributes: permitted_rights_params }
      permitted << { specimen_type_attributes: permitted_specimen_type_params }
      permitted << { complex_version_attributes: permitted_version_params }
      permitted << { custom_property_attributes: permitted_custom_property_params }
    end
  end
end
