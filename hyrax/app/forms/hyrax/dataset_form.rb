# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  # Generated form for Dataset
  class DatasetForm < Hyrax::Forms::WorkForm
    attr_reader :agreement_accepted, :supervisor_agreement_accepted
    self.model_class = ::Dataset
    delegate :keyword_ordered, :specimen_set_ordered, :managing_organization_ordered, to: :model

    self.terms -= [
      # Fields not interested in
      :based_near, :contributor, :creator, :date_created, :identifier, :license,
      :related_url, :source,
      # Fields interested in, but removing to re-order
      :title, :description, :keyword, :language, :publisher, :resource_type, :subject
      # Fields that are not displayed
      # :import_url, :date_modified, :date_uploaded, :depositor, :bibliographic_citation,
      # :date_created, :label, :relative_path
    ]

    self.terms += [
      # Adding all fields in order of display in form

      # description
      :managing_organization_ordered,
      :first_published_url,
      :title, :alternative_title, 
      :resource_type, :data_origin, 
      :description, :keyword_ordered,
      :specimen_set_ordered, 
      :publisher, :date_published, 
      :rights_statement, :licensed_date,
      :complex_person, 
      :complex_source, :manuscript_type, 
      :complex_event,
      :language, 
      :complex_date,
      :complex_identifier, 
      :complex_version,
      :complex_funding_reference,
      :complex_relation, 
      :custom_property,

      # method
      :characterization_methods, 
      :computational_methods,
      :properties_addressed, 
      :synthesis_and_processing,

      # instruments
      :complex_instrument, 

      # specimen details
      :complex_specimen_type,
      :complex_chemical_composition,
      :complex_structural_feature,
      :material_type,
      
      # not used
      :complex_organization, :origin_system_provenance, :subject, # not used
      
      # draft
      :draft
    ]

    self.required_fields -= [
      # Fields not interested in
      :creator, :keyword,
      # Fields interested in, but removing to re-order
      :title]

    self.required_fields += [
      # Adding all required fields in order of display in form
      :managing_organization_ordered, :title, :resource_type, :data_origin,
      :description, :keyword_ordered, :date_published, :rights_statement
    ]

    def metadata_tab_terms
      [
        # Description tab order determined here
        :managing_organization_ordered,
        :first_published_url,
        :title, :alternative_title, 
        :resource_type, :data_origin,
        :description, :keyword_ordered, 
        :specimen_set_ordered, 
        :material_type,
        :publisher, :date_published, 
        :rights_statement, :licensed_date, 
        :complex_person, 
        :complex_source, :manuscript_type,
        :complex_event,
        :language,
        :complex_date, 
        :complex_identifier, 
        :complex_version,
        :complex_funding_reference,
        :complex_relation,
        :custom_property
      ]
    end

    def method_tab_terms
      [
        # Method tab order determined here
        :characterization_methods, :computational_methods,
        # :origin_system_provenance, # not using this
        :properties_addressed,
        :synthesis_and_processing
      ]
    end

    def instrument_tab_terms
      [ :complex_instrument ]
    end

    def specimen_tab_terms
      [ :complex_chemical_composition, :complex_specimen_type, :complex_structural_feature ]
    end

    NESTED_ASSOCIATIONS = [:complex_date, :complex_identifier, :complex_instrument,
      :complex_organization, :complex_person, :complex_relation, :complex_event,
      :complex_funding_reference, :complex_chemical_composition,
      :complex_structural_feature,
      :complex_source, :complex_specimen_type, :complex_version, :custom_property].freeze

    protected

    def self.permitted_affiliation_params
      [:id,
       :_destroy,
       {
         job_title: [],
         complex_organization_attributes: permitted_organization_params,
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

    def self.permitted_date_params
      [:id,
       :_destroy,
       {
         date: [],
         description: []
       }
      ]
    end

    def self.permitted_desc_id_params
      [:id,
       :_destroy,
       {
         description: [],
         complex_identifier_attributes: permitted_identifier_params,
       }
      ]
    end

    def self.permitted_fundref_params
      [:id,
       :_destroy,
       {
         funder_identifier: [],
         funder_name: [],
         award_number: [],
         award_uri: [],
         award_title: []
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
         instrument_function_attributes: permitted_instrument_function_params,
         manufacturer_attributes: permitted_organization_params,
         model_number: [],
         complex_person_attributes: permitted_person_params,
         managing_organization_attributes: permitted_organization_params,
         title: []
       }
      ]
    end

    def self.permitted_instrument_function_params
      [:id,
       :_destroy,
       {
         column_number: [],
         category: [],
         # sub_category: [],
         description: []
       }
      ]
    end

    def self.permitted_material_type_params
      [:id,
       :_destroy,
       {
         material_type: [],
         description: [],
         complex_identifier_attributes: permitted_identifier_params,
         material_sub_type: []
       }
      ]
    end

    def self.permitted_organization_params
      [:id,
       :_destroy,
       {
         organization: [],
         sub_organization: [],
         purpose: [],
         complex_identifier_attributes: permitted_identifier_params,
       }
      ]
    end

    def self.permitted_person_params
      [:id,
        :_destroy,
        :corresponding_author,
        :display_order,
       {
         last_name: [],
         first_name: [],
         name: [],
         role: [],
         orcid: [],
         organization: [],
         sub_organization: [],
         complex_affiliation_attributes: permitted_affiliation_params,
         complex_identifier_attributes: permitted_identifier_params,
         uri: []
       }
      ]
    end

    def self.permitted_purchase_record_params
      [:id,
       :_destroy,
       {
         date: [],
         complex_identifier_attributes: permitted_identifier_params,
         supplier_attributes: permitted_organization_params,
         manufacturer_attributes: permitted_organization_params,
         purchase_record_item: [],
         title: []
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
         complex_chemical_composition_attributes: permitted_desc_id_params,
         complex_crystallographic_structure_attributes: permitted_desc_id_params,
         description: [],
         complex_identifier_attributes: permitted_identifier_params,
         complex_material_type_attributes: permitted_material_type_params,
         # complex_purchase_record_attributes: permitted_purchase_record_params,
         complex_structural_feature_attributes: permitted_structural_feature_params,
         title: []
       }
      ]
    end

    def self.permitted_chemical_composition_params
      [:id,
       :_destroy,
       {
         description: [],
         complex_identifier_attributes: permitted_identifier_params,
         category: []
       }
      ]
    end

    def self.permitted_structural_feature_params
      [:id,
       :_destroy,
       {
         category: [],
         description: [],
         complex_identifier_attributes: permitted_identifier_params,
         # sub_category: []
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

    def self.permitted_event_params
      [:id,
       :_destroy,
       {
         title: [],
         place: [],
         start_date: [],
         end_date: [],
         invitation_status: []
       }
      ]
    end

    def self.permitted_source_params
      [:id,
       :_destroy,
       {
         alternative_title: [],
         end_page: [],
         issue: [],
         sequence_number: [],
         start_page: [],
         title: [],
         total_number_of_pages: [],
         volume: [],
         issn: []
       }
      ]
    end

    def self.build_permitted_params
      permitted = super
      permitted << { complex_date_attributes: permitted_date_params }
      permitted << :licensed_date
      permitted << { complex_identifier_attributes: permitted_identifier_params }
      permitted << { complex_instrument_attributes: permitted_instrument_params }
      permitted << { complex_person_attributes: permitted_person_params }
      permitted << { complex_organization_attributes: permitted_organization_params }
      permitted << { complex_relation_attributes: permitted_relation_params }
      permitted << { complex_specimen_type_attributes: permitted_specimen_type_params }
      permitted << { complex_version_attributes: permitted_version_params }
      permitted << { complex_event_attributes: permitted_event_params }
      permitted << { complex_source_attributes: permitted_source_params }
      permitted << { custom_property_attributes: permitted_custom_property_params }
      permitted << { complex_funding_reference_attributes: permitted_fundref_params }
      permitted << { complex_chemical_composition_attributes: permitted_chemical_composition_params }
      permitted << { complex_structural_feature_attributes: permitted_structural_feature_params }
      permitted << :member_of_collection_ids
      permitted << :find_child_work
    end
  end

end
