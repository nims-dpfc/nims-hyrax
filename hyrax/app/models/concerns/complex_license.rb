# !!! Dummy model added by @nabeta !!!
class ComplexLicense < ActiveTriples::Resource
  include CommonMethods

  # dummy
  configure type: ::RDF::URI.new('http://www.niso.org/schemas/ali/1.0/license_ref')
  property :license_ref, predicate: ::RDF::Vocab::Identifiers.uri


  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#identifier#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
