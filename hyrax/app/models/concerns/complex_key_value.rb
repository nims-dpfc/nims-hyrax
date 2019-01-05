class ComplexKeyValue < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['CustomProperty']
  property :label, predicate: ::RDF::Vocab::DISCO.question
  property :description, predicate: ::RDF::Vocab::SIOC.has_reply

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#key_value#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end
end
