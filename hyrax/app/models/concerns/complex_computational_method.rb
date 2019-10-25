class ComplexComputationalMethod < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['ComplexComputationalMethod']
  property :calculation_method, predicate: ::RDF::Vocab::NimsRdp.calculation_method
  property :description, predicate: ::RDF::Vocab::DC11.description
  property :key_object_description, predicate: ::RDF::Vocab::NimsRdp.key_object_description
  property :machine_type, predicate: ::RDF::Vocab::NimsRdp.machine_type
  property :operation_system, predicate: ::RDF::Vocab::NimsRdp.operation_system
  property :software_description, predicate: ::RDF::Vocab::NimsRdp.software_description
  property :software_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :software_identifier
  property :software_name, predicate: ::RDF::Vocab::NimsRdp['software-name']
  property :software_version_information, predicate: ::RDF::Vocab::NimsRdp.software_version_information
  property :specimen_description, predicate: ::RDF::Vocab::NimsRdp.specimen_description
  property :specimen_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :software_identifier

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#complex-computational-method#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
