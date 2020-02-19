module Hyrax
  class CitationsController < ApplicationController
    include WorksControllerBehavior
    include Breadcrumbs
    include SingularSubresourceController
    prepend ::DisableApiBehavior

    # Overrides decide_layout from WorksControllerBehavior
    with_themed_layout '1_column'

    before_action :build_breadcrumbs, only: [:work, :file]

    def work
      show
    end

    def file
      # We set _@presenter_ here so it isn't set in WorksControllerBehavior#presenter
      # which is intended to find works (not files)
      solr_file = ::SolrDocument.find(params[:id])
      authorize! :show, solr_file
      @presenter = NimsFileSetPresenter.new(solr_file, current_ability, request)
      show
    end

    private

      # nims override to select correct presenter
      def show_presenter
        case find_work.class.to_s
        when 'Dataset'
          DatasetPresenter
        when 'Image'
          ImagePresenter
        when 'Publication'
          PublicationPresenter
        when 'Work'
          WorkPresenter
        else
          WorkShowPresenter
        end
      end
  end
end
