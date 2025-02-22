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
      :title, :alternate_title, 
      :resource_type, :data_origin, 
      :description, :keyword_ordered,
      :specimen_set_ordered, 
      :publisher, :date_published, 
      :rights_statement, :licensed_date,
      :license_description,
      :complex_person, 
      :complex_contact_agent,
      :complex_source, :manuscript_type, 
      :complex_event,
      :language,
      :complex_identifier, 
      :complex_version,
      :complex_funding_reference,
      :complex_relation, 
      :custom_property,

      # method
      :characterization_methods, 
      :properties_addressed, 
      :synthesis_and_processing,
      :complex_feature,
      :complex_computational_method,
      :complex_experimental_method,

      # instruments
      :complex_instrument,
      :complex_instrument_operator,

      # specimen details
      :complex_specimen_type,
      :complex_chemical_composition,
      :complex_structural_feature,
      :complex_crystallographic_structure,
      :complex_software,
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
      :title, :resource_type, :data_origin, :description, :keyword_ordered, :date_published, :rights_statement
    ]

    def metadata_tab_terms
      [
        # Description tab order determined here
        :managing_organization_ordered,
        :first_published_url,
        :title, :alternate_title, 
        :resource_type, :data_origin,
        :description, :keyword_ordered, 
        :specimen_set_ordered, 
        :material_type,
        :publisher, :date_published, 
        :rights_statement, :licensed_date,
        :license_description,
        :complex_person, 
        :complex_contact_agent,
        :complex_source, :manuscript_type,
        :complex_event,
        :language,
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
        :characterization_methods,
        # :origin_system_provenance, # not using this
        :properties_addressed,
        :synthesis_and_processing,
        :complex_experimental_method,
        :complex_computational_method,
        :complex_feature,
        :complex_software
      ]
    end

    def instrument_tab_terms
      [
        :complex_instrument,
        :complex_instrument_operator
      ]
    end

    def specimen_tab_terms
      [ :complex_chemical_composition, :complex_specimen_type, :complex_structural_feature, :complex_crystallographic_structure ]
    end

    NESTED_ASSOCIATIONS = [:complex_identifier, :complex_instrument,
      :complex_organization, :complex_person, :complex_relation, :complex_event,
      :complex_funding_reference, :complex_contact_agent, :complex_chemical_composition,
      :complex_crystallographic_structure,
      :complex_structural_feature, :complex_software, :complex_feature,
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

    def self.permitted_contact_agent_params
      [:id,
       :_destroy,
       {
         name: [],
         email: [],
         organization: [],
         department: []
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
         date_collected: [],
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

    def self.permitted_instrument_operator_params
      [:id,
       :_destroy,
       {
         name: [],
         email: [],
         organization: [],
         department: []
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
         issn: [],
         article_number: []
       }
      ]
    end

		def self.permitted_crystallographic_structure_params
      [:id,
       :_destroy,
       {
         specimen_identifier: [],
         category_vocabulary: [],
         category_description: [],
         description: []
       }
      ]
    end

    def self.permitted_feature_params
      [:id,
       :_destroy,
       {
         category_vocabulary: [],
         unit_vocabulary: [],
         value: [],
         identifier: [],
         description: []
       }
      ]
    end

    def self.permitted_software_params
      [:id,
       :_destroy,
       {
         name: [],
         version: [],
         identifier: [],
         description: []
       }
      ]
    end

    def self.permitted_computational_method_params
      [:id,
       :_destroy,
       {
         category_vocabulary: [],
         category_description: [],
         calculated_at: [],
         description: []
       }
      ]
    end

    def self.permitted_experimental_method_params
      [:id,
       :_destroy,
       {
         category_vocabulary: [],
         category_description: [],
         analysis_field_vocabulary: [],
         analysis_field_description: [],
         measurement_environment_vocabulary: [],
         standarized_procedure_vocabulary: [],
         measured_at: [],
         description: []
       }
      ]
    end

    def self.build_permitted_params
      permitted = super
      permitted << :licensed_date
      permitted << :license_description
      permitted << { complex_identifier_attributes: permitted_identifier_params }
      permitted << { complex_instrument_attributes: permitted_instrument_params }
      permitted << { complex_instrument_operator_attributes: permitted_instrument_operator_params }
      permitted << { complex_person_attributes: permitted_person_params }
      permitted << { complex_organization_attributes: permitted_organization_params }
      permitted << { complex_relation_attributes: permitted_relation_params }
      permitted << { complex_specimen_type_attributes: permitted_specimen_type_params }
      permitted << { complex_version_attributes: permitted_version_params }
      permitted << { complex_event_attributes: permitted_event_params }
      permitted << { complex_source_attributes: permitted_source_params }
      permitted << { custom_property_attributes: permitted_custom_property_params }
      permitted << { complex_funding_reference_attributes: permitted_fundref_params }
      permitted << { complex_contact_agent_attributes: permitted_contact_agent_params }
      permitted << { complex_chemical_composition_attributes: permitted_chemical_composition_params }
      permitted << { complex_structural_feature_attributes: permitted_structural_feature_params }
      permitted << { complex_crystallographic_structure_attributes: permitted_crystallographic_structure_params }
      permitted << { complex_feature_attributes: permitted_feature_params }
      permitted << { complex_software_attributes: permitted_software_params }
      permitted << { complex_computational_method_attributes: permitted_computational_method_params }
      permitted << { complex_experimental_method_attributes: permitted_experimental_method_params }
      permitted << :find_child_work
    end
  end

end
