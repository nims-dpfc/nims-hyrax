# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  # Generated form for Work
  class WorkForm < Hyrax::Forms::WorkForm
    attr_reader :agreement_accepted, :supervisor_agreement_accepted
    self.model_class = ::Work
    self.terms += [:resource_type, :licensed_date]
  end
end
