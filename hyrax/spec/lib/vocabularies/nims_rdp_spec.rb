require 'rails_helper'
require './lib/vocabularies/nims_rdp'

RSpec.describe RDF::Vocab::NimsRdp do
  it { expect(described_class).to be <  RDF::Vocabulary }
  it { expect(subject.value).to start_with 'http://www.nims.go.jp/vocabs/ngdr/' }
end
