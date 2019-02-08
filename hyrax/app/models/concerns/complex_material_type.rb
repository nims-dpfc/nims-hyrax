# !!! Dummy model added by @nabeta !!!
class ComplexMaterialType < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['MaterialType']

  property :material_type, predicate: ::RDF::Vocab::NimsRdp["material-type"]
  property :sub_material_type, predicate: ::RDF::Vocab::NimsRdp["material-type"]
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
