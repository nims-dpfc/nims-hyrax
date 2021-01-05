# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  # Generated controller for Dataset
  class DatasetsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include ::ComplexFieldsBehavior
    self.curation_concern_type = ::Dataset

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DatasetPresenter

    def create
      safe_dataset_params = params['dataset'].permit(::Hyrax::DatasetForm.build_permitted_params)

      # NB: need to cleanup twice
      params['dataset'] = cleanup_params(cleanup_instrument_and_specimen_type(cleanup_params(safe_dataset_params.to_h)))
      params['dataset']['draft'] = ['true'] if params["save_draft_with_files"] == "Save Draft"
      super
    end

    def update
      safe_dataset_params = params['dataset'].permit(::Hyrax::DatasetForm.build_permitted_params)
      # NB: need to cleanup twice
      params['dataset'] = cleanup_params(cleanup_instrument_and_specimen_type(cleanup_params(safe_dataset_params.to_h)))
      if params["save_draft_with_files"] == "Save Draft"
        params['dataset']['draft'] = ['true']
      else
        params['dataset']['draft'] = ['false']
      end
      super
    end

  end
end
