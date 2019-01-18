require './lib/vocabularies/escidoc_publication'

class Publication < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = PublicationIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your publication must have a title.' }

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


  # NOTE: Not a part of Hyrax basic metadata
  # Not defining this field. It raises RSolr::Error::ConnectionRefused when added to index.
  # property :part_of, predicate: ::RDF::Vocab::DC.isPartOf do |index|
  #   index.as :stored_searchable
  # end

  # NGDR Hyrax Work Common
  property :alternative_title, predicate: ::RDF::Vocab::DC.alternative, multiple: false do |index|
    index.as :stored_searchable
  end

  property :complex_date, predicate: ::RDF::Vocab::DC.date, class_name: 'ComplexDate'

  property :complex_identifier, predicate: ::RDF::Vocab::NimsRdp.identifier, class_name: 'ComplexIdentifier'

  property :complex_person, predicate: ::RDF::Vocab::SIOC.has_creator, class_name: 'ComplexPerson'

  # TODO: Need more information
  # property :complex_license, predicate: ::RDF::URI.new('http://www.niso.org/schemas/ali/1.0/license_ref'), class_name:'ComplexLicense'

  property :complex_rights, predicate: ::RDF::Vocab::DC11.rights, class_name: 'ComplexRights'

  property :complex_version, predicate: ::RDF::Vocab::NimsRdp['complex-version'], class_name: 'ComplexVersion'

  # NGDR Hyrax Work Publication MVP
  # Note: all date fields are covered by complex_date in Hyrax Work Common above

  property :complex_event, predicate: ::RDF::Vocab::ESciDocPublication['complex-event'], class_name: 'ComplexEvent'

  property :issue, predicate: ::RDF::Vocab::ESciDocPublication['issue'], multiple: false do |index|
    index.as :stored_searchable
  end

  property :place, predicate: ::RDF::Vocab::ESciDocPublication['place'], multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :total_number_of_pages, predicate: ::RDF::Vocab::ESciDocPublication['total-pages'], multiple: false do |index|
    index.as :stored_searchable, :sortable, type: :integer
  end


  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  include ComplexValidation
  accepts_nested_attributes_for :complex_date, reject_if: :date_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_identifier, reject_if: :identifier_blank, allow_destroy: true
  # accepts_nested_attributes_for :complex_license, reject_if: :license_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_person, reject_if: :person_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_rights, reject_if: :rights_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_version, reject_if: :version_blank, allow_destroy: true
  accepts_nested_attributes_for :complex_event, reject_if: :event_blank, allow_destroy: true

end
