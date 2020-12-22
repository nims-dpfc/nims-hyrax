class PIDRequest < Struct.new(:id, :localId, :creator, :disclosureLevel, :pidCategory)
  def initialize(h)
    super(*h.values_at(*self.class.members))
    self.id ||= SecureRandom.uuid
    self.pidCategory ||= 'DATA_IDENTIFIER'
    self.disclosureLevel ||= 'PRIVATE'
  end
end
