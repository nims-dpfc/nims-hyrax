require "./lib/vocabularies/nims_rdp"
class Dataset < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = DatasetIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your dataset must have a title.' }

  property :analysis_field, predicate: ::RDF::Vocab::NimsRdp['analysis-field'] do |index|
    index.as :stored_searchable
  end

  property :characterization_methods, predicate: ::RDF::Vocab::NimsRdp['characterization-methods'] do |index|
    index.as :stored_searchable
  end

  property :computational_methods, predicate: ::RDF::Vocab::NimsRdp['computational-methods'] do |index|
    index.as :stored_searchable
  end

  property :data_origin, predicate: ::RDF::Vocab::NimsRdp['data-origin'] do |index|
    index.as :stored_searchable
  end

  property :material_types, predicate: ::RDF::Vocab::NimsRdp['material-types'] do |index|
    index.as :stored_searchable
  end

  property :measurement_environment, predicate: ::RDF::Vocab::NimsRdp['measurement-environment'] do |index|
    index.as :stored_searchable
  end

  property :processing_environment, predicate: ::RDF::Vocab::NimsRdp['processing-environment'] do |index|
    index.as :stored_searchable
  end

  property :properties_addressed, predicate: ::RDF::Vocab::NimsRdp['properties-addressed'] do |index|
    index.as :stored_searchable
  end

  property :structural_features, predicate: ::RDF::Vocab::NimsRdp['structural-features'] do |index|
    index.as :stored_searchable
  end

  # nims-rdp_synthesis_and_processing
  property :synthesis_and_processing, predicate: ::RDF::Vocab::NimsRdp['synthesis-and-processing'] do |index|
    index.as :stored_searchable
  end

  # property dces_contributor - defined in the basic metadata
  # property dces_creator - defined in the basic metadata
  # Have described a complex person here
  #   This could be used to describe contributor and creator
  property :complex_person, predicate: ::RDF::Vocab::SIOC.has_creator, class_name:"ComplexPerson"

  # property dces_description - defined in the basic metadata
  # property dces_keyword - defined in the basic metadata
  # property dces_language - defined in the basic metadata
  # property dces_publisher - defined in the basic metadata
  # property dces_subject - defined in the basic metadata
  # property dct_bibliographic_citation - defined in the basic metadata
  # property dct_date_created - defined in the basic metadata

  # property dct_identifier - defined in the basic metadata
  # Have described a complex identifier here
  #   This could be used to describe the identifier
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup, class_name:"ComplexIdentifier"

  property :part_of, predicate: ::RDF::Vocab::DC.isPartOf do |index|
    index.as :stored_searchable
  end

  # property dct_resource_type - defined in the basic metadata
  # property dct_rights - defined in the basic metadata
  # property dct_source - defined in the basic metadata
  # property edm_rights_statement - defined in the basic metadata
  # property fedora_label
  # property foaf_based_near - defined in the basic metadata
  # property rdfs_related_url - defined in the basic metadata
  # property scholarsphere_import_url - defined in the basic metadata
  # property scholarsphere_relative_path - defined in the basic metadata
  # property dct_date_modified - defined in core metadata
  # property dct_date_uploaded - defined in core metadata
  # property dct_title - defined in core metadata
  # property marc-relators_depositor - defined in core metadata

  property :status_at_start, predicate: ::RDF::Vocab::NimsRdp['status-at-start'], multiple: false do |index|
    index.as :stored_searchable
  end

  property :status_at_end, predicate: ::RDF::Vocab::NimsRdp['status-at-end'], multiple: false do |index|
    index.as :stored_searchable
  end

  property :instrument, predicate: ::RDF::Vocab::NimsRdp['instrument'], multiple: false do |index|
    index.as :stored_searchable
  end

  # Have described a complex date here
  #   This could be used to describe different dates
  property :complex_date, predicate: ::RDF::Vocab::DC.date, class_name:"ComplexDate"

  # Have described a complex relation here
  #   This could be used to describe relationships by giving more context to the relation
  #   could be used in place of part_of and related_url
  property :complex_relation, predicate: ::RDF::Vocab::DC.relation, class_name:"ComplexRelation"

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  accepts_nested_attributes_for :complex_person, reject_if: :person_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_identifier, reject_if: :identifier_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_date, reject_if: :date_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_relation, reject_if: :relation_blank, allow_destroy: true
  include ComplexAttributes
end
