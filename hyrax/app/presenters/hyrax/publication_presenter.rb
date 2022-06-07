# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationPresenter < Hyrax::WorkShowPresenter
    delegate :alternative_title, :complex_date, :complex_identifier, :complex_person,
             :complex_rights, :complex_version, :complex_event, :issue, :place,
             :table_of_contents, :total_number_of_pages,
             :complex_funding_reference, :complex_source,
             :complex_contact_agent,
             :complex_relation, :custom_property, :specimen_set,
             :first_published_url, :doi, :licensed_date, :creator, :date_published,
             :managing_organization, to: :solr_document

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
