class ComplexComputationalMethod < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['ComplexComputationalMethod']
  property :calculation_method, predicate: ::RDF::Vocab::NimsRdp['calculation-method']
  property :description, predicate: ::RDF::Vocab::DC11.description
  property :key_object_description, predicate: ::RDF::Vocab::NimsRdp['key-object-description']
  property :key_object_identifier, predicate: ::RDF::Vocab::NimsRdp['key-object-identifier'],
            class_name: "ComplexIdentifier"
  property :machine_type, predicate: ::RDF::Vocab::NimsRdp['machine-type']
  property :operation_system, predicate: ::RDF::Vocab::NimsRdp['operation-system']
  property :software_description, predicate: ::RDF::Vocab::NimsRdp['software-description']
  property :software_identifier, predicate: ::RDF::Vocab::NimsRdp['software-identifier'],
            class_name: "ComplexIdentifier"
  property :software_name, predicate: ::RDF::Vocab::NimsRdp['software-name']
  property :software_version_information, predicate: ::RDF::Vocab::NimsRdp['software-version-information']
  property :specimen_description, predicate: ::RDF::Vocab::NimsRdp['specimen-description']
  property :specimen_identifier, predicate: ::RDF::Vocab::NimsRdp['specimen-identifier'],
            class_name: "ComplexIdentifier"
  accepts_nested_attributes_for :key_object_identifier #, reject_if: :all_blank
  accepts_nested_attributes_for :software_identifier #, reject_if: :all_blank
  accepts_nested_attributes_for :specimen_identifier #, reject_if: :all_blank

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
