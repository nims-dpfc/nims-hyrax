# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  # Generated form for Publication
  class PublicationForm < Hyrax::Forms::WorkForm
    self.model_class = ::Publication
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
      :first_published_url, :supervisor_approval,
      :title, :alternative_title, :rights_statement, :complex_person, :description, :keyword_ordered, :date_published,
      :publisher, :resource_type, :complex_date, :manuscript_type,
      :complex_identifier, :complex_source, :complex_version, :complex_relation,
      :complex_event, :specimen_set_ordered, :managing_organization_ordered,
      :language, :licensed_date, :custom_property, :note_to_admin
    ]

    self.required_fields -= [
      # Fields not interested in
      :creator, :keyword,
      # Fields interested in, but removing to re-order
      :title, :rights_statement]

    self.required_fields += [
      # Adding all required fields in order of display in form
      :supervisor_approval, :title, :resource_type, :specimen_set_ordered,
      :description, :keyword_ordered, :date_published, :rights_statement
    ]

    def metadata_tab_terms
      [
        # Description tab order determined here
        :first_published_url, :supervisor_approval,
        :title, :alternative_title, :language, :resource_type, :description, :keyword_ordered,
        :complex_person, :manuscript_type, :publisher, :specimen_set_ordered, :managing_organization_ordered,
        :date_published, :rights_statement, :licensed_date,
        :complex_identifier, :complex_source, :complex_version, :complex_relation,
        :custom_property, :note_to_admin
      ]
    end

    NESTED_ASSOCIATIONS = [:complex_date, :complex_identifier,
      :complex_person, :complex_version, :complex_event, :complex_source].freeze

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
        :contact_person,
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
         issn: []
       }
      ]
    end

    def self.build_permitted_params
      permitted = super
      permitted << { complex_date_attributes: permitted_date_params }
      permitted << :licensed_date
      permitted << { complex_identifier_attributes: permitted_identifier_params }
      permitted << { complex_person_attributes: permitted_person_params }
      permitted << { complex_relation_attributes: permitted_relation_params }
      permitted << { complex_version_attributes: permitted_version_params }
      permitted << { complex_event_attributes: permitted_event_params }
      permitted << { complex_source_attributes: permitted_source_params }
      permitted << { custom_property_attributes: permitted_custom_property_params }
      permitted << :member_of_collection_ids
      permitted << :find_child_work
    end
  end
end
