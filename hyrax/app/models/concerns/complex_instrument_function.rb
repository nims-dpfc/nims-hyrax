# !!! Dummy model added by @nabeta !!!
class ComplexInstrumentFunction < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['InstrumentFunction']

  property :complex_category_code, predicate: ::RDF::Vocab::NimsRdp["category-code"],
    class_name:"ComplexCategoryCode"


  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#instrument#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
