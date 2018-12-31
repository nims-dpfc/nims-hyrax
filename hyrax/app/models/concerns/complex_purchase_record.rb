class ComplexPurchaseRecord < ActiveTriples::Resource
  configure type: ::RDF::Vocab::NimsRdp['PurchaseRecord']

  property :date, predicate: ::RDF::Vocab::DC.date

  property :identifier, predicate: ::RDF::Vocab::DC.identifier

  property :purchase_record_item, predicate: ::RDF::Vocab::NimsRdp["purchase-record-item"]

  property :title, predicate: ::RDF::Vocab::DC.title
end
