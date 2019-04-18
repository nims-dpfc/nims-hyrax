class ComplexInstrumentFunction < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['InstrumentFunction']
  property :column_number, predicate: ::RDF::Vocab::NimsRdp["column-number"]
  property :category, predicate: ::RDF::Vocab::NimsRdp["category"]
  property :sub_category, predicate: ::RDF::Vocab::NimsRdp["sub-category"]
  property :description, predicate: ::RDF::Vocab::DC11.description

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#category_code#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
