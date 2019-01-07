# Provide select options for data origin
class PropertiesAddressedService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('properties_addressed')
  end
end
