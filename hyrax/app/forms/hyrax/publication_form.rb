# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  # Generated form for Publication
  class PublicationForm < Hyrax::Forms::WorkForm
    attr_reader :agreement_accepted, :supervisor_agreement_accepted
    self.model_class = ::Publication
    delegate :keyword_ordered, :specimen_set_ordered, :managing_organization_ordered, to: :model
    self.terms -= [
      # Fields not interested in
      :based_near, :contributor, :creator, :date_created, :identifier, :license,
      :related_url, :source,
      # Fields interested in, but removing to re-order
      :title, :description, :keyword, :language, :publisher, :resource_type,
      :subject
      # Fields that are not displayed
      # :import_url, :date_modified, :date_uploaded, :depositor, :bibliographic_citation,
      # :date_created, :label, :relative_path
    ]

    self.terms += [
      # Adding all fields in order of display in form
      :managing_organization_ordered,
      :first_published_url,
      :title, :alternate_title, 
      :resource_type, 
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
      :custom_property, :draft
    ]

    self.required_fields -= [
      # Fields not interested in
      :creator, :keyword,
      # Fields interested in, but removing to re-order
      :title, :rights_statement]

    self.required_fields += [
      # Adding all required fields in order of display in form
      :title, :resource_type, :description, :keyword_ordered,
      :date_published, :rights_statement
    ]

    def metadata_tab_terms
      [
        # Description tab order determined here
        :managing_organization_ordered,
        :first_published_url,
        :title, :alternate_title, 
        :resource_type, 
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
        :custom_property
      ]
    end

    NESTED_ASSOCIATIONS = [:complex_identifier,
      :complex_person, :complex_version, :complex_funding_reference,
      :complex_event, :complex_source, :complex_contact_agent
    ].freeze

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

    def self.build_permitted_params
      permitted = super
      permitted << :licensed_date
      permitted << :license_description
      permitted << { complex_identifier_attributes: permitted_identifier_params }
      permitted << { complex_person_attributes: permitted_person_params }
      permitted << { complex_relation_attributes: permitted_relation_params }
      permitted << { complex_version_attributes: permitted_version_params }
      permitted << { complex_event_attributes: permitted_event_params }
      permitted << { complex_source_attributes: permitted_source_params }
      permitted << { custom_property_attributes: permitted_custom_property_params }
      permitted << { complex_funding_reference_attributes: permitted_fundref_params }
      permitted << { complex_contact_agent_attributes: permitted_contact_agent_params }
      permitted << :find_child_work
    end
  end
end
