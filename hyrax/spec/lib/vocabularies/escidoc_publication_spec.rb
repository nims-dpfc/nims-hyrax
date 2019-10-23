require 'rails_helper'
require './lib/vocabularies/escidoc_publication'

RSpec.describe RDF::Vocab::ESciDocPublication do
  it { expect(described_class).to be <  RDF::Vocabulary }
  it { expect(subject.value).to start_with 'http://purl.org/escidoc/metadata/terms/0.1/' }
end
