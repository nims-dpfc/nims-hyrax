# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  class DatasetPresenter < Hyrax::WorkShowPresenter
    delegate :alternative_title, :complex_date, :complex_identifier,
      :complex_person, :complex_organization, :complex_rights, :complex_version,
      :characterization_methods, :computational_methods, :data_origin,
      :complex_instrument, :origin_system_provenance, :properties_addressed,
      :complex_relation, :specimen_set, :complex_specimen_type, :complex_event,
      :complex_source,
      :synthesis_and_processing, :custom_property, :first_published_url, :doi,
      :creator, :licensed_date, :date_published, to: :solr_document

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::NimsFileSetPresenter
    prepend ::FilteredGraph

    def manuscript_type
      ManuscriptTypeService.new.find_by_id(solr_document.manuscript_type.first)&.[](:label) if solr_document.manuscript_type.present?
    end
  end
end
