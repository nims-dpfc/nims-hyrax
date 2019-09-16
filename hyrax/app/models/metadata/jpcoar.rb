# The JPCOAR metadata format for MDR
class Metadata::Jpcoar < OAI::Provider::Metadata::Format
  
  def initialize
    @prefix = 'jpcoar'
    @schema = 'https://github.com/JPCOAR/schema/blob/master/1.0/jpcoar_scm.xsd'
    @namespace = 'https://github.com/JPCOAR/schema/blob/master/1.0/'
    @element_namespace = 'jpcoar'
    @fields = %i[title
                 alternative
                 creator
                 contributor
                 accessRights
                 apc
                 rights
                 rightsHolder
                 subject
                 description
                 publisher
                 date
                 language
                 type
                 version
                 version
                 identifier
                 identifierRegistration
                 relation
                 temporal
                 geoLocation
                 fundingReference
                 sourceIdentifier
                 sourceTitle
                 volume
                 issue
                 numPages
                 pageStart
                 pageEnd
                 dissertationNumber
                 degreeName
                 dateGranted
                 degreeGrantor
                 conference
                 file]
  end

  def header_specification
    {
      'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
      'xmlns:dcterms' => 'http://purl.org/dc/terms/',
      'xmlns:rioxxterms' => 'http://www.rioxx.net/schema/v2.0/rioxxterms/',
      'xmlns:datacite' => 'https://schema.datacite.org/meta/kernel-4/',
      'xmlns:openaire' => 'http://namespace.openaire.eu/schema/oaire/',
      'xmlns:dcndl' => 'http://ndl.go.jp/dcndl/terms/',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'xsi:schemaLocation ' => 'https://github.com/JPCOAR/schema/blob/master/1.0/jpcoar_scm.xsd'
    }
  end
end
