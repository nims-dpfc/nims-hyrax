# Generated via
#  `rails generate hyrax:work Dataset`
class DatasetIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  # Custom indexers for dataset model
  include ComplexField::DateIndexer
  include ComplexField::IdentifierIndexer
  include ComplexField::CustomPropertyIndexer
  include ComplexField::PersonIndexer
  include ComplexField::RightsIndexer
  include ComplexField::VersionIndexer
  include ComplexField::InstrumentIndexer
  include ComplexField::RelationIndexer
  include ComplexField::SpecimenTypeIndexer
end
