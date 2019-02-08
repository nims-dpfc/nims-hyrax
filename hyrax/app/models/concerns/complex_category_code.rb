# !!! Dummy model added by @nabeta !!!
class ComplexCategoryCode < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['CategoryCode']

  property :column_number, predicate: ::RDF::Vocab::NimsRdp["column-number"]
  property :main_category_type, predicate: ::RDF::Vocab::NimsRdp["category-type"]
  property :sub_category_type, predicate: ::RDF::Vocab::NimsRdp["category-type"]


  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#instrument#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
