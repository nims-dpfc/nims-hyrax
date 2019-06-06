# The JPCOAR metadata format for MDR
class Metadata::Jpcoar < OAI::Provider::Metadata::Format

  def initialize
    @prefix = 'jpcoar'
    @schema = 'https://github.com/JPCOAR/schema/blob/master/1.0/jpcoar_scm.xsd'
    @namespace = 'https://github.com/JPCOAR/schema/blob/master/1.0/'
  end

end
