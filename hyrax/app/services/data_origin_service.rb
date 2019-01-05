# Provide select options for data origin
class DataOriginService < QaSelectServiceExtended
  def initialize(_authority_name = nil)
    super('data_origin')
  end
end
