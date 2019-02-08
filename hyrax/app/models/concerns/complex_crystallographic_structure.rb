# !!! Dummy model added by @nabeta !!!
class ComplexCrystallographicStructure < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['CrystallographicStructure']

  property :description, predicate: ::RDF::Vocab::DC.description
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"


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
