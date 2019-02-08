# !!! Dummy model added by @nabeta !!!
class ComplexAffiliation < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::SCHEMA.affiliation

  property :organization, predicate: ::RDF::Vocab::SCHEMA.Organization,
    class_name:"ComplexOrganization"
  property :title, predicate: ::RDF::Vocab::SCHEMA.jobTitle


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
