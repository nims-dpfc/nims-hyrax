# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkPresenter < Hyrax::WorkShowPresenter
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::NimsFileSetPresenter
    prepend ::FilteredGraph
  end
end
