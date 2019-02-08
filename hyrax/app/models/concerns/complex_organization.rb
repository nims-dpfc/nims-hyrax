# !!! Dummy model added by @nabeta !!!
class ComplexOrganization < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::SCHEMA.Organization
  property :name, predicate: ::RDF::Vocab::FOAF.name
  # <http://id.exaample.jp/id/1> foaf:name
  #   "National Institute for Materials Science"@en,
  #   "物質・材料研究機構"@ja;

  # ISNI, GRID?
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier
  property :uri, predicate: ::RDF::Vocab::Identifiers.uri


  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#person#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
