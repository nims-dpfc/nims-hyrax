# Generated via
#  `rails generate hyrax:work Image`
class ImageIndexer < NgdrIndexer
  # Custom indexers for image model
  include ComplexField::DateIndexer
  include ComplexField::IdentifierIndexer
  include ComplexField::PersonIndexer
  include ComplexField::RightsIndexer
  include ComplexField::VersionIndexer
end
