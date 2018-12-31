# Provide select options for data origin
class PropertiesAddressedService < Hyrax::QaSelectService
  def initialize(_authority_name = nil)
    super('properties_addressed')
  end
end
