# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  # Generated form for Publication
  class PublicationForm < Hyrax::Forms::WorkForm
    self.model_class = ::Publication
    self.terms += [:resource_type]
  end
end
