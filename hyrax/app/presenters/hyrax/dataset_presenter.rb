# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  class DatasetPresenter < Hyrax::WorkShowPresenter
    delegate :alternate_title, :complex_identifier,
      :complex_person, :complex_organization, :complex_rights, :complex_version,
      :complex_funding_reference, :characterization_methods, :computational_methods, :data_origin,
      :complex_contact_agent, :complex_chemical_composition, :complex_structural_feature,
      :complex_instrument, :complex_instrument_operator,
      :origin_system_provenance, :properties_addressed,
      :complex_relation, :specimen_set, :complex_specimen_type, :complex_event,
      :complex_crystallographic_structure,
      :complex_source, :complex_feature, :complex_software,
      :complex_computational_method, :complex_experimental_method,
      :material_type,
      :synthesis_and_processing, :custom_property, :first_published_url, :doi,
      :creator, :licensed_date, :license_description, :date_published,
      :managing_organization, :ordered_creators, to: :solr_document

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::NimsFileSetPresenter
    prepend ::FilteredGraph

    def page_title
      "#{title.first} // #{I18n.t('hyrax.product_name')}"
    end

    def manuscript_type
      ManuscriptTypeService.new.find_by_id(solr_document.manuscript_type.first)&.[](:label) if solr_document.manuscript_type.present?
    end
  end
end
