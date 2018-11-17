# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  # Generated controller for Dataset
  class DatasetsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Dataset

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DatasetPresenter
  end
end
