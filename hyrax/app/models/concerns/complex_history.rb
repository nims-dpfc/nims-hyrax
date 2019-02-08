# !!! Dummy model added by @nabeta !!!
class ComplexHistory < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['History']
  property :upstream, predicate: ::RDF::Vocab::NimsRdp['System']
  property :downstream, predicate: ::RDF::Vocab::NimsRdp['System']

  # need to update Date vocabulary (e.g. transported_at, deposited_at)
  property :date, predicate: ::RDF::Vocab::Bibframe.eventDate
  property :operator, predicate: ::RDF::Vocab::SIOC.has_administrator, class_name: 'ComplexPerson'


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
