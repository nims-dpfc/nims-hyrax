class ComplexFundingReference < ActiveTriples::Resource
  include CommonMethods
  configure type: ::RDF::Vocab::NimsRdp.FundingReference
  property :funder_identifier, predicate: ::RDF::Vocab::NimsRdp.funderIdentifier
  property :funder_name, predicate: ::RDF::Vocab::NimsRdp.funderName
  property :award_number, predicate: ::RDF::Vocab::NimsRdp.awardNumber
  property :award_uri, predicate: ::RDF::Vocab::NimsRdp.awardURI
  property :award_title, predicate: ::RDF::Vocab::NimsRdp.awardTitle

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#fundref#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end
end
