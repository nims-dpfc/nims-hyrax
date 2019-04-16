class ComplexInstrumentFunction < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['InstrumentFunction']
  property :column_number, predicate: ::RDF::Vocab::NimsRdp["column-number"]
  property :main_category_type, predicate: ::RDF::Vocab::NimsRdp["category-type"]
  property :sub_category_type, predicate: ::RDF::Vocab::NimsRdp["category-sub-type"]
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
