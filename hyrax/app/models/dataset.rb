require "./lib/vocabularies/nims_rdp"
require "./lib/vocabularies/oaire_terms"

class Dataset < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = DatasetIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your dataset must have a title.' }

  # property date_modified - defined in core metadata
  # property date_uploaded - defined in core metadata
  # property depositor - defined in core metadata
  # property title - defined in core metadata
  # property based_near - defined in the basic metadata
  # property bibliographic_citation - defined in the basic metadata
  # property contributor - defined in the basic metadata
  # property creator - defined in the basic metadata
  # property date_created - defined in the basic metadata
  # property description - defined in the basic metadata
  # property identifier - defined in the basic metadata
  # property import_url - defined in the basic metadata
  # property keyword - defined in the basic metadata
  # property label - defined in the basic metadata
  # property language - defined in the basic metadata
  # property publisher - defined in the basic metadata
  # property related_url - defined in the basic metadata
  # property relative_path - defined in the basic metadata
  # property resource_type - defined in the basic metadata
  # property license (rights) - defined in the basic metadata
  # property rights_statement - defined in the basic metadata
  # property source - defined in the basic metadata
  # property subject - defined in the basic metadata

  # Required due to bug saving nested resources
  property :updated_subresources, predicate: ::RDF::URI.new('http://example.com/updatedSubresources'), class_name: "ActiveTriples::Resource"

  property :alternate_title, predicate: ::RDF::Vocab::DC.alternative, multiple: false do |index|
    index.as :stored_searchable
  end

  property :complex_identifier, predicate: ::RDF::Vocab::NimsRdp.identifier, class_name:"ComplexIdentifier"

  property :complex_person, predicate: ::RDF::Vocab::SIOC.has_creator, class_name:"ComplexPerson"

  property :complex_rights, predicate: ::RDF::Vocab::DC11.rights, class_name:"ComplexRights"

  property :complex_version, predicate: ::RDF::Vocab::NimsRdp.version, class_name:"ComplexVersion"

  property :complex_organization, predicate: ::RDF::Vocab::ORG.organization, class_name:"ComplexOrganization"

  property :complex_event, predicate: ::RDF::Vocab::ESciDocPublication.event, class_name: 'ComplexEvent'

  property :characterization_methods, predicate: ::RDF::Vocab::NimsRdp['characterization-methods'] do |index|
    index.as :stored_searchable, :facetable
  end

  property :computational_methods, predicate: ::RDF::Vocab::NimsRdp['computational-methods'] do |index|
    index.as :stored_searchable, :facetable
  end

  # TODO - This is required
  property :data_origin, predicate: ::RDF::Vocab::NimsRdp['data-origin'] do |index|
    index.as :stored_searchable, :facetable
  end

  ##
  # We need a local term to store whether the work is a draft
  property :draft, predicate: 'http://local.authority/draft'

  ##
  # Convenience method to determine whether a work is in a draft state
  def draft?
    return false if draft.empty?
    return false unless draft.first.to_s == 'true'
    true
  end

  property :complex_instrument, predicate: ::RDF::Vocab::NimsRdp.instrument, class_name: "ComplexInstrument"

  property :complex_instrument_operator, predicate: ::RDF::Vocab::NimsRdp.instrument_operator, class_name: "ComplexInstrumentOperator"

  property :origin_system_provenance, predicate: ::RDF::Vocab::NimsRdp['origin-system-provenance'], multiple: false do |index|
    index.as :stored_searchable
  end

  # NOTE: Not a part of Hyrax basic metadata
  # Not defining this field. It raises RSolr::Error::ConnectionRefused when added to index.
  # property :part_of, predicate: ::RDF::Vocab::DC.isPartOf do |index|
  #   index.as :stored_searchable
  # end

  property :properties_addressed, predicate: ::RDF::Vocab::NimsRdp['properties-addressed'] do |index|
    index.as :stored_searchable, :facetable
  end

  # Defined complex_relation in common_complex_properties in place of relation
  #   This could be used to describe relationships by giving more context to the relation
  #   could be used in place of part_of and related_url
  property :complex_relation, predicate: ::RDF::Vocab::DC.relation, class_name:"ComplexRelation"

  property :complex_source, predicate: ::RDF::Vocab::ESciDocPublication.source, class_name: 'ComplexSource'

  property :specimen_set, predicate: ::RDF::Vocab::NimsRdp['specimen-set'] do |index|
    index.as :stored_searchable, :facetable
  end

  property :complex_specimen_type, predicate: ::RDF::Vocab::NimsRdp['specimen-type'],
  class_name: "ComplexSpecimenType"

  property :complex_chemical_composition, predicate: ::RDF::Vocab::NimsRdp['chemical-composition'],
    class_name: "ComplexChemicalComposition"

  property :complex_structural_feature, predicate: ::RDF::Vocab::NimsRdp['structural-feature'],
    class_name: "ComplexStructuralFeature"

  property :complex_crystallographic_structure, predicate: ::RDF::Vocab::NimsRdp['crystallographic-structure'],
    class_name: "ComplexCrystallographicStructure"

  property :complex_feature, predicate: ::RDF::Vocab::NimsRdp['feature'],
    class_name: "ComplexFeature"

  property :complex_software, predicate: ::RDF::Vocab::SCHEMA.SoftwareApplication,
    class_name: "ComplexSoftware"

  property :synthesis_and_processing, predicate: ::RDF::Vocab::NimsRdp['synthesis-and-processing'] do |index|
    index.as :stored_searchable, :facetable
  end

  property :custom_property, predicate: ::RDF::Vocab::NimsRdp['custom-property'], class_name:"ComplexKeyValue"

  property :supervisor_approval, predicate: ::RDF::Vocab::NimsRdp['supervisor-approval']

  property :first_published_url, predicate: ::RDF::Vocab::NimsRdp['first_published_url'], multiple: false do |index|
    index.as :stored_searchable
  end

  property :doi, predicate: ::RDF::Vocab::Identifiers.doi, multiple: false do |index|
    index.as :stored_searchable
  end

  property :licensed_date, predicate: ::RDF::Vocab::NimsRdp['licenced-date'], multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :license_description, predicate: ::RDF::Vocab::NimsRdp['licence-description'], multiple: false do |index|
    index.as :stored_searchable
  end

  property :date_published, predicate: ::RDF::Vocab::NimsRdp['date_published'], multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :manuscript_type, predicate: ::RDF::Vocab::OaireTerms.version, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :managing_organization, predicate: ::RDF::Vocab::NimsRdp['contributor'] do |index|
    index.as :stored_searchable, :facetable
  end

  property :nims_pid, predicate: ::RDF::Vocab::NimsRdp['nims-pid'], multiple: false do |index|
    index.as :stored_searchable
  end

  property :material_type, predicate: ::RDF::Vocab::NimsRdp["material-type"] do |index|
    index.as :stored_searchable, :facetable
  end

  property :complex_funding_reference, predicate: ::RDF::Vocab::DataCite.fundref, class_name:"ComplexFundingReference"

  property :complex_contact_agent, predicate: ::RDF::Vocab::DCAT.contactPoint, class_name: 'ComplexContactAgent'

  property :complex_computational_method, predicate: ::RDF::Vocab::NimsRdp["computational-method"], class_name: 'ComplexComputationalMethod'

  property :complex_experimental_method, predicate: ::RDF::Vocab::NimsRdp["experimental-method"], class_name: 'ComplexExperimentalMethod'

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  include ComplexValidation
  include OrderedFields
  accepts_nested_attributes_for :complex_identifier, reject_if: :identifier_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_instrument, reject_if: :instrument_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_instrument_operator, reject_if: :person_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_organization, reject_if: :organization_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_person, reject_if: :person_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_relation, reject_if: :relation_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_rights, reject_if: :rights_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_specimen_type, reject_if: :specimen_type_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_version, reject_if: :version_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_event, reject_if: :event_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_source, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :custom_property, reject_if: :key_value_blank, allow_destroy: true
  accepts_nested_attributes_for :updated_subresources, allow_destroy: true
  accepts_nested_attributes_for :complex_funding_reference, reject_if: :fundref_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_contact_agent, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_chemical_composition, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_structural_feature, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_crystallographic_structure, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_feature, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_software, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_computational_method, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_experimental_method, reject_if: :all_blank, allow_destroy: true
end
