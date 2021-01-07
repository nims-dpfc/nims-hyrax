# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  # Generated controller for Publication
  class PublicationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include ::ComplexFieldsBehavior
    self.curation_concern_type = ::Publication

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::PublicationPresenter

    def create
      safe_params = params['publication'].permit(::Hyrax::PublicationForm.build_permitted_params)
      params['publication'] = cleanup_params(safe_params.to_h)
      params['publication']['draft'] = ['true'] if params["save_draft_with_files"] == "Save Draft"
      super
    end

    def update
      safe_params = params['publication'].permit(::Hyrax::PublicationForm.build_permitted_params)
      params['publication'] = cleanup_params(safe_params.to_h)
      if params["save_draft_with_files"] == "Save Draft"
        params['publication']['draft'] = ['true']
      else
        params['publication']['draft'] = ['false']
      end
      super
    end

  end
end
