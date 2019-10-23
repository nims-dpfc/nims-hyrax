require 'rails_helper'
require './lib/vocabularies/rioxx_terms'

RSpec.describe RDF::Vocab::RioxxTerms do
  it { expect(described_class).to be <  RDF::Vocabulary }
  it { expect(subject.value).to start_with 'http://data2paper.org/vocabularies/rioxxterms#' }
end
