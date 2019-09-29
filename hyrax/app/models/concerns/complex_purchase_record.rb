class ComplexPurchaseRecord < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['PurchaseRecord']

  property :date, predicate: ::RDF::Vocab::NimsRdp["purchase-date"]

  property :complex_identifier, predicate: ::RDF::Vocab::NimsRdp["purchase-record-identifier"],
            class_name: "ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  property :supplier, predicate: ::RDF::Vocab::NimsRdp["supplier"],
            class_name: "ComplexOrganization"
  accepts_nested_attributes_for :supplier

  property :manufacturer, predicate: ::RDF::Vocab::NimsRdp["manufacturer"],
            class_name: "ComplexOrganization"
  accepts_nested_attributes_for :manufacturer

  property :purchase_record_item, predicate: ::RDF::Vocab::NimsRdp["purchase-record-item"]

  property :title, predicate: ::RDF::Vocab::NimsRdp["purchase-record-title"]

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#purchase_record#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
