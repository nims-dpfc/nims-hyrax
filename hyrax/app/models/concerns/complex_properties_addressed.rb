class ComplexPropertiesAddressed < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['PropertiesAddressed']
  property :arbitrary, predicate: ::RDF::Vocab::NimsRdp['arbitrary']

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#complex-properties-addressed#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
