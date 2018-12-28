module RDF
  module Vocab
    class ESciDocPublication < RDF::Vocabulary("http://colab.mpdl.mpg.de/mediawiki/ESciDoc_Application_Profile_Publication")
      property 'complex-event'
      property 'issue'
      property 'place'
      property 'total-pages'
    end
  end
end
