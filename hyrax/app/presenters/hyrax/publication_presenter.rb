# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationPresenter < Hyrax::WorkShowPresenter
    delegate :alternative_title, :complex_date, :complex_identifier,
             :complex_person, :complex_rights, :complex_version, :complex_event,
             :issue, :place, :total_number_of_pages, to: :solr_document
  end
end
