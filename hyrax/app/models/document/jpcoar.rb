# frozen_string_literal: true

require 'builder'

# This module provide Jpcoar export based on the document's semantic values
module Document::Jpcoar
  def self.extended(document)
    # Register our exportable formats
    Document::Jpcoar.register_export_formats(document)
  end

  def self.register_export_formats(document)
    document.will_export_as(:jpcoar_xml, 'text/xml')
  end

  # JA - these are taken from formats/jpcoar (although there are two 'version' (datacite and openaire) so I've just used datacite)
  # JA - I've done these as hashes so we can map field name to the field with the correct namespace / name
  # JA - the namespace bit might be wrong, we may just want them all to be jpcoar?
  def jpcoar_field_names
    { title: 'dc:title',
      alternative: 'dcterms:alternative',
      creator: 'jpcoar:creator',
      contributor: 'jpcoar:contributor',
      access_rights: 'dcterms:accessRights',
      apc: 'rioxxterms:apc',
      rights: 'dc:rights',
      rights_older: 'jpcoar:rightsHolder',
      subject: 'jpcoar:subject',
      description: 'datacite:description',
      publisher: 'dc:publisher',
      date: 'datacite:date',
      language: 'dc:language',
      type: 'dc:type',
      version: 'datacite:version',
      identifier: 'jpcoar:identifier',
      identifier_registration: 'jpcoar:identifierRegistration',
      relation: 'jpcoar:relation',
      temporal: 'dcterms:temporal',
      geo_location: 'datacite:geoLocation',
      funding_reference: 'jpcoar:fundingReference',
      source_identifier: 'jpcoar:sourceIdentifier',
      source_title: 'jpcoar:sourceTitle',
      volume: 'jpcoar:volume',
      issue: 'jpcoar:issue',
      num_pages: 'jpcoar:numPages',
      page_start: 'jpcoar:pageStart',
      page_end: 'jpcoar:pageEnd',
      dissertation_number: 'dcndl:dissertationNumber',
      degree_name: 'dcndl:degreeName',
      dateGranted: 'dcndl:dateGranted',
      degree_grantor: 'jpcoar:degreeGrantor',
      conference: 'jpcoar:conference',
      file: 'jpcoar:file' }
  end

  # jpcoar elements are mapped against the #jpcoar_field_names whitelist.
  # JA - I think jpcoar is a nested xml so this will need to be refactored
  def export_as_jpcoar_xml
    xml = Builder::XmlMarkup.new
    xml.tag!('jpcoar',
             'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
             'xmlns:dcterms' => 'http://purl.org/dc/terms/',
             'xmlns:rioxxterms' => 'http://www.rioxx.net/schema/v2.0/rioxxterms/',
             'xmlns:datacite' => 'https://schema.datacite.org/meta/kernel-4/',
             'xmlns:openaire' => 'http://namespace.openaire.eu/schema/oaire/',
             'xmlns:dcndl' => 'http://ndl.go.jp/dcndl/terms/',
             'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
             'xsi:schemaLocation ' => 'https://github.com/JPCOAR/schema/blob/master/1.0/jpcoar_scm.xsd') do
      to_semantic_values.select { |field, _values| jpcoar_field_name? field }.each do |field, values|
        Array.wrap(values).each do |v|
          xml.tag! jpcoar_field_names[field], v
        end
      end
    end
    xml.target!
  end

  private

  def jpcoar_field_name?(field)
    jpcoar_field_names.keys.include? field.to_sym
  end
end
