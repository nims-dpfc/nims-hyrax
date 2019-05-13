class ComplexAffiliation < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::MADS.Affiliation

  property :complex_organization, predicate: ::RDF::Vocab::ORG.organization,
            class_name:"ComplexOrganization"
  accepts_nested_attributes_for :complex_organization
  property :job_title, predicate: ::RDF::Vocab::SCHEMA.jobTitle


  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#affiliation#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
