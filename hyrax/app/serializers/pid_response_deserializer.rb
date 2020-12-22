class PIDResponseDeserializer < JSONAPI::Deserializable::Resource
  type
  id
  attributes :canonicalId, :pidCategory, :localId, :disclosureLevel, :created
end

