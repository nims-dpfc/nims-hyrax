module RDF
  module Vocab
    class NimsRdp < RDF::Vocabulary("http://www.nims.go.jp/vocabs/ngdr/")
      property 'analysis-field'
      property 'characterization-methods'
      property 'computational-methods'
      property 'data-origin'
      property 'material-types'
      property 'measurement-environment'
      property 'processing-environment'
      property 'properties-addressed'
      property 'structural-features'
      property 'synthesis-and-processing'
      property 'status-at-start'
      property 'status-at-end'
      property 'instrument'
    end
  end
end
