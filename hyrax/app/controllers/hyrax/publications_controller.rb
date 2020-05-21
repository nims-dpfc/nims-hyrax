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
      super
    end

    def update
      safe_params = params['publication'].permit(::Hyrax::PublicationForm.build_permitted_params)
      params['publication'] = cleanup_params(safe_params.to_h)
      super
    end

  end
end
