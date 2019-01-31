dataset_attributes = {
  title: ['test dataset 1234'],
  description: ['description 1'],
  keyword: ['keyword 1', 'keyword 2'],
  language: ['language 1'],
  publisher: ['publisher 1'],
  complex_rights_attributes: [{
    date: '1978-10-28',
    rights: 'CC0'
  }],
  rights_statement: ['rights_statement 1'],
  source: ['Source 1'],
  subject: ['subject 1'],
  alternative_title: 'Alternative Title',
  complex_date_attributes: [{
    date: '1978-10-28',
    description: 'http://purl.org/dc/terms/issued',
  }],
  complex_identifier_attributes: [{
    identifier: '10.0.0132132',
    scheme: 'http://dx.doi.org',
    label: 'DOI'
  }],
  complex_person_attributes: [{
    name: 'Foo Bar',
    affiliation: 'author affiliation',
    role: 'Author',
    complex_identifier_attributes: [{
      identifier: '1234567',
      scheme: 'Local'
    }],
    uri: 'http://localhost/person/1234567'
  }],
  complex_version_attributes: [{
    date: '2018-10-28',
    description: 'Creating the first version',
    identifier: 'id1',
    version: '1.0'
  }],
  characterization_methods: 'charge distribution',
  computational_methods: 'computational methods',
  data_origin: ['informatics and data science'],
  instrument_attributes: [{
    alternative_title: 'An instrument title',
    complex_date_attributes: [{
      date: ['2018-02-14'],
      description: 'Processed'
    }],
    description: 'Instrument description',
    complex_identifier_attributes: [{
      identifier: ['123456'],
      label: ['Local']
    }],
    function_1: ['Has a function'],
    function_2: ['Has two functions'],
    manufacturer: 'Manufacturer name',
    complex_person_attributes: [{
      name: ['Name of operator'],
      role: ['Operator']
    }],
    organization: 'Organisation',
    title: 'Instrument title'
  }],
  origin_system_provenance: 'origin system provenance',
  properties_addressed: ['chemical -- impurity concentration'],
  complex_relation_attributes: [{
    title: 'A related item',
    url: 'http://example.com/relation',
    complex_identifier_attributes: [{
      identifier: ['123456'],
      label: ['local']
    }],
    relationship: 'isSupplementTo'
  }],
  specimen_set: 'Specimen set',
  specimen_type_attributes: [{
    chemical_composition: 'chemical composition',
    crystallographic_structure: 'crystallographic structure',
    description: 'Description',
    complex_identifier_attributes: [{
      identifier: '1234567'
    }],
    material_types: 'material types',
    purchase_record_attributes: [{
      date: ['2018-02-14'],
      identifier: ['123456'],
      purchase_record_item: ['Has a purchase record item'],
      title: 'Purchase record title'
    }],
    complex_relation_attributes: [{
      url: 'http://example.com/relation',
      relationship: 'isPreviousVersionOf'
    }],
    structural_features: 'structural features',
    title: 'Instrument 1'
  }],
  synthesis_and_processing: 'Synthesis and processing methods',
  custom_property_attributes: [{
    question: 'Full name',
    response: 'My full name is ...'
  }]
}
