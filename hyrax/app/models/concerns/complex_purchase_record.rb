class ComplexPurchaseRecord < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['PurchaseRecord']

  property :date, predicate: ::RDF::Vocab::NimsRdp["purchase-record-date"]

  property :identifier, predicate: ::RDF::Vocab::NimsRdp["purchase-record-identifier"]

  property :purchase_record_item, predicate: ::RDF::Vocab::NimsRdp["purchase-record-item"]

  property :title, predicate: ::RDF::Vocab::NimsRdp["purchase-record-title"]
  property :supplier, predicate: ::RDF::Vocab::NimsRdp["supplier"],
    class_name:"ComplexOrganization"
  property :manufacturer, predicate: ::RDF::Vocab::NimsRdp["manufacturer"],
    class_name:"ComplexOrganization"


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
