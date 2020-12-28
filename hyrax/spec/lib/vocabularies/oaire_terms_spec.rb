require 'rails_helper'
require './lib/vocabularies/oaire_terms'

RSpec.describe RDF::Vocab::OaireTerms do
  it { expect(described_class).to be <  RDF::Vocabulary }
  it { expect(subject.value).to start_with 'http://lod.openaire.eu/vocab#' }
end
