class PIDRequestSerializer < JSONAPI::Serializable::Resource
  type 'pid'
  attributes :localId, :creator, :disclosureLevel, :pidCategory
end
