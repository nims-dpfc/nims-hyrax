module RDF
  module Vocab
    class ESciDocPublication < RDF::Vocabulary("http://purl.org/escidoc/metadata/terms/0.1/")
      property :Event
      property :Source
      property :creator
      property 'end-page'
      property :event
      property :issue
      property :place
      property 'sequence-number'
      property 'start-page'
      property 'total-number-of-pages'
      property :source
      property :volume
    end
  end
end
