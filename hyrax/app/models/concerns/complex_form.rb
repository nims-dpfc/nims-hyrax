# !!! Dummy model added by @nabeta !!!
class ComplexForm < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['Form']

  property :shape, predicate: ::RDF::Vocab::NimsRdp["shape"],
    class_name:"ComplexShape"
  property :state_of_matter, predicate: ::RDF::Vocab::NimsRdp["state_of_matter"],
    class_name:"ComplexStateOfMatter"


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
