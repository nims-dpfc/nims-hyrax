module CommonComplexProperties
  extend ActiveSupport::Concern
  included do

    property :complex_date, predicate: ::RDF::Vocab::DC.date, class_name:"ComplexDate"

    property :complex_person, predicate: ::RDF::Vocab::SIOC.has_creator, class_name:"ComplexPerson"

    property :complex_identifier, predicate: ::RDF::Vocab::NimsRdp.identifier, class_name:"ComplexIdentifier"

    property :complex_rights, predicate: ::RDF::Vocab::DC11.rights, class_name:"ComplexRights"

    property :complex_version, predicate: ::RDF::Vocab::NimsRdp['complex-version'], class_name:"ComplexVersion"

    # Have described a complex relation here
    #   This could be used to describe relationships by giving more context to the relation
    #   could be used in place of part_of and related_url
    property :complex_relation, predicate: ::RDF::Vocab::DC.relation, class_name:"ComplexRelation"

    # TODO: Need more information
    # property :complex_license, predicate: ::RDF::URI.new('http://www.niso.org/schemas/ali/1.0/license_ref'), class_name:"ComplexLicense"

    accepts_nested_attributes_for :complex_date, reject_if: :date_blank, allow_destroy: true
    accepts_nested_attributes_for :complex_person, reject_if: :person_blank, allow_destroy: true
    accepts_nested_attributes_for :complex_identifier, reject_if: :identifier_blank, allow_destroy: true
    accepts_nested_attributes_for :complex_rights, reject_if: :rights_blank, allow_destroy: true
    accepts_nested_attributes_for :complex_version, reject_if: :version_blank, allow_destroy: true
    accepts_nested_attributes_for :complex_relation, reject_if: :identifier_blank, allow_destroy: true

    # accepts_nested_attributes_for :complex_license, reject_if: :license_blank, allow_destroy: true

  end
end
