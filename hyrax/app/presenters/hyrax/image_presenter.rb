# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    delegate :alternative_title, :complex_date, :complex_identifier, :complex_person,
      :complex_rights, :complex_version, :status, to: :solr_document
  end
end
