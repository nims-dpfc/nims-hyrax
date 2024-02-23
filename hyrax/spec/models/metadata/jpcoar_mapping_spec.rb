require 'rails_helper'

RSpec.describe Metadata::JpcoarMapping do

  describe do
    let(:field) {'my_field'}
    let(:xml) { Builder::XmlMarkup.new }

    describe 'jpcoar_managing_organization' do
      let(:model) { build(:dataset, :with_managing_organization) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'
        <jpcoar:contributor contributorType="HostingInstitution">
          <jpcoar:affiliation>
              <jpcoar:affiliationName xml:lang="en">Managing organization</jpcoar:affiliationName>
          </jpcoar:affiliation>
        </jpcoar:contributor>
      '}
      it 'has the xml' do
        solr_document.jpcoar_managing_organization(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_first_published_url' do
      let(:model) { build(:dataset, :with_first_published_url) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'
        <jpcoar:relation relationType="isVersionOf">
          <jpcoar:relatedIdentifier identifierType="URI">http://example.com/first-published-url</jpcoar:relatedIdentifier>
        </jpcoar:relation>
      '}
      it 'has the xml' do
        solr_document.jpcoar_first_published_url(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_title' do
      let(:model) { build(:dataset) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<dc:title xml:lang="en">Dataset</dc:title>'}
      it 'has the xml' do
        solr_document.jpcoar_title(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_alternate_title' do
      let(:model) { build(:dataset, :with_alternate_title) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<dcterms:alternative xml:lang="en">Alternative-Title-123</dcterms:alternative>'}
      it 'has the xml' do
        solr_document.jpcoar_alternate_title(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_resource_type' do
      rmap = {
          'Article' => 'http://purl.org/coar/resource_type/c_6501',
          'Audio' => 'http://purl.org/coar/resource_type/c_18cc',
          'Book' => 'http://purl.org/coar/resource_type/c_2f33',
          'Conference Proceeding' => 'http://purl.org/coar/resource_type/c_f744',
          'Dataset' => 'http://purl.org/coar/resource_type/c_ddb1',
          'Dissertation' => 'http://purl.org/coar/resource_type/c_46ec',
          'Image' => 'http://purl.org/coar/resource_type/c_c513',
          'Journal' => 'http://purl.org/coar/resource_type/c_2659',
          'Part of Book' => 'http://purl.org/coar/resource_type/c_3248',
          'Poster' => 'http://purl.org/coar/resource_type/c_6670',
          'Presentation' => 'http://purl.org/coar/resource_type/c_c94f',
          'Report' => 'http://purl.org/coar/resource_type/c_93fc',
          'Software or Program Code' => 'http://purl.org/coar/resource_type/c_5ce6',
          'Video' => 'http://purl.org/coar/resource_type/c_12ce',
          'Other' => 'http://purl.org/coar/resource_type/c_1843',
        }
      rmap.each do |k, v|
        context k do
          let(:model) { build(:dataset, resource_type: [k]) }
          let(:solr_document) { SolrDocument.new(model.to_solr) }
          let(:out) {"<dc:type rdf:resource=\"#{v}\">#{k}</dc:type>"}
          it "has the xml" do
            solr_document.jpcoar_resource_type(field, xml)
            expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
          end
        end
      end
    end

    describe 'jpcoar_description' do
      let(:model) { build(:dataset, :with_description_abstract) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<datacite:description descriptionType="Abstract" xml:lang="en">Abstract-Description-123</datacite:description>'}
      it 'has the xml' do
        solr_document.jpcoar_description(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_keyword' do
      let(:model) { build(:dataset, :with_keyword) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<jpcoar:subject subjectScheme="Other" xml:lang="en">Keyword-123</jpcoar:subject>'}
      it 'has the xml' do
        solr_document.jpcoar_keyword(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_publisher' do
      let(:model) { build(:dataset, :with_publisher) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<dc:publisher xml:lang="en">Publisher-123</dc:publisher>'}
      it 'has the xml' do
        solr_document.jpcoar_publisher(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_date_published' do
      let(:model) { build(:dataset, :with_date_published) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<datacite:date dateType="Issued">1978-10-28</datacite:date>'}
      it 'has the xml' do
        solr_document.jpcoar_date_published(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_rights_statement' do
      let(:model) { build(:dataset, :with_rights) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<dc:rights rdf:resource="https://creativecommons.org/publicdomain/zero/1.0/legalcode" xml:lang="en">
        Creative Commons Zero v1.0 Universal</dc:rights>'}
      it 'has the xml' do
        solr_document.jpcoar_rights_statement(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_complex_person' do
      context 'with role author' do
        let(:model) do
          build(:dataset, complex_person_attributes: [{
            name: 'Anamika',
            first_name: 'First name',
            last_name: 'Last name',
            role: ['author'],
            orcid: '23542345234',
            organization: 'My org'
          }])
        end
        let(:solr_document) { SolrDocument.new(model.to_solr) }
        let(:out) {'
          <jpcoar:creator>
            <jpcoar:familyName xml:lang="en">Last name</jpcoar:familyName>
            <jpcoar:givenName xml:lang="en">First name</jpcoar:givenName>
            <jpcoar:creatorName xml:lang="en">Anamika</jpcoar:creatorName>
            <jpcoar:nameIdentifier nameIdentifierScheme="ORCID" nameIdentifierURI="23542345234">23542345234</jpcoar:nameIdentifier>
            <jpcoar:affiliation>
              <jpcoar:affiliationName xml:lang="en">My org</jpcoar:affiliationName>
            </jpcoar:affiliation>
          </jpcoar:creator>
        '}
        it 'has the xml' do
          solr_document.jpcoar_complex_person(field, xml)
          expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
        end
      end
      role_map = {
        'editor' => 'Editor',
        'translator' => 'Other',
        'data depositor' => 'Other',
        'data curator' =>	'DataCurator',
        'contact person' => 'ContactPerson',
        'operator' =>	'Other'
      }
      role_map.each do |k, v|
        context "with role #{k}" do
          let(:model) do
            build(:dataset, complex_person_attributes: [{
              name: 'Anamika',
              first_name: 'First name',
              last_name: 'Last name',
              role: [k],
              orcid: '23542345234',
              organization: 'My org'
            }])
          end
          let(:solr_document) { SolrDocument.new(model.to_solr) }
          let(:out) {"
            <jpcoar:contributor contributorType=\"#{v}\">
              <jpcoar:familyName xml:lang=\"en\">Last name</jpcoar:familyName>
              <jpcoar:givenName xml:lang=\"en\">First name</jpcoar:givenName>
              <jpcoar:contributorName xml:lang=\"en\">Anamika</jpcoar:contributorName>
              <jpcoar:nameIdentifier nameIdentifierScheme=\"ORCID\" nameIdentifierURI=\"23542345234\">23542345234</jpcoar:nameIdentifier>
              <jpcoar:affiliation>
                <jpcoar:affiliationName xml:lang=\"en\">My org</jpcoar:affiliationName>
              </jpcoar:affiliation>
            </jpcoar:contributor>
          "}
          it 'has the xml' do
            solr_document.jpcoar_complex_person(field, xml)
            expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
          end
        end
      end
    end

    describe 'jpcoar_complex_source' do
      let(:model) { build(:dataset, :with_complex_source) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'
        <jpcoar:sourceTitle xml:lang="en">Test journal</jpcoar:sourceTitle>
        <jpcoar:sourceIdentifier identifierType="ISSN">1234-5678</jpcoar:sourceIdentifier>
        <jpcoar:volume>3</jpcoar:volume>
        <jpcoar:issue>34</jpcoar:issue>
        <jpcoar:pageStart>4</jpcoar:pageStart>
        <jpcoar:pageEnd>12</jpcoar:pageEnd>
        <jpcoar:numPages>8</jpcoar:numPages>
      '}
      it 'has the xml' do
        solr_document.jpcoar_complex_source(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_manuscript_type' do
      m_map = {
        'Original' => {'uri' => 'http://purl.org/coar/version/c_b1a7d7d4d402bcce', 'label' => 'AO'},
        'Accepted' => {'uri' => 'http://purl.org/coar/version/c_ab4af688f83e57aa', 'label' => 'AM' },
        'Proof' => {'uri' => 'http://purl.org/coar/version/c_fa2ee174bc00049f', 'label' => 'P' },
        'Version' => {'uri' => 'http://purl.org/coar/version/c_970fb48d4fbd8a85', 'label' => 'VoR' },
        'other' => {'uri' => 'http://purl.org/coar/version/c_be7fb7dd8ff6fe43', 'label' => 'NA'},
      }
      m_map.each do |k, v|
        context k do
          let(:model) { build(:dataset, manuscript_type: k) }
          let(:solr_document) { SolrDocument.new(model.to_solr) }
          let(:out) {"<oaire:version rdf:resource=\"#{v['uri']}\">#{v['label']}</oaire:version>"}
          it "has the xml" do
            solr_document.jpcoar_manuscript_type(field, xml)
            expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
          end
        end
      end
    end

    describe 'jpcoar_complex_event' do
      let(:model) { build(:dataset, :with_complex_event) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'
        <jpcoar:conference>
          <jpcoar:conferenceName xml:lang="en">Event-Title-123</jpcoar:conferenceName>
          <jpcoar:conferencePlace xml:lang="en">New Scotland Yard</jpcoar:conferencePlace>
          <jpcoar:conferenceDate xml:lang="en" startDay="25" startMonth="12" startYear="2018" endDay="1" endMonth="1" endYear="2019">2018-12-25 to 2019-01-01</jpcoar:conferenceDate>
        </jpcoar:conference>
      '}
      it 'has the xml' do
        solr_document.jpcoar_complex_event(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_complex_date' do
      c_map = {
        'http://purl.org/dc/terms/dateAccepted' => 'Accepted',
        'Available' => 'Available',
        'http://bibframe.org/vocab/copyrightDate' => 'Copyrighted',
        'Collected' => 'Collected',
        'http://purl.org/dc/terms/created' => 'Created',
        'http://bibframe.org/vocab/providerDate' => 'Submitted',
        'http://bibframe.org/vocab/changeDate' => 'Updated',
      }
      c_map.each do |k, v|
        context k do
          let(:model) { build(:dataset,
                              complex_date_attributes: [{
                                date: '1978-10-28',
                                description: k
                              }]) }
          let(:solr_document) { SolrDocument.new(model.to_solr) }
          let(:out) {"<datacite:date dateType=\"#{v}\">1978-10-28</datacite:date>"}
          it "has the xml" do
            solr_document.jpcoar_complex_date(field, xml)
            expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
          end
        end
      end
      context 'without label' do
        let(:model) { build(:dataset,
                            complex_date_attributes: [{ date: '1978-10-28'}]) }
        let(:solr_document) { SolrDocument.new(model.to_solr) }
        it "has the xml" do
          solr_document.jpcoar_complex_date(field, xml)
          expect(xml.target!.gsub(/<to_s\/>/, '')).to be_empty
        end
      end
    end

    describe 'jpcoar_complex_identifier' do
      let(:model) { build(:dataset, :with_complex_identifier) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<jpcoar:identifier identifierType="DOI">10.0.1111</jpcoar:identifier>'}
      it 'has the xml' do
        solr_document.jpcoar_complex_identifier(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_complex_version' do
      let(:model) { build(:dataset, :with_complex_version) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {'<datacite:version>1.0</datacite:version>'}
      it 'has the xml' do
        solr_document.jpcoar_complex_version(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar_complex_relation' do
      context 'isNewVersionOf' do
        let(:model) { build(:dataset, :with_complex_relation) }
        let(:solr_document) { SolrDocument.new(model.to_solr) }
        let(:out) {'
          <jpcoar:relation relationType="isVersionOf">
            <jpcoar:relatedTitle xml:lang="en">A relation label</jpcoar:relatedTitle>
            <jpcoar:relatedIdentifier identifierType="URI">http://example.com/relation</jpcoar:relatedIdentifier>
          </jpcoar:relation>
        '}
        it "has the xml" do
          solr_document.jpcoar_complex_relation(field, xml)
          expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
        end
      end
      r_map = {
        'isPreviousVersionOf' => 'hasVersion',
        'isSupplementTo' => 'isSupplementTo',
        'isSupplementedBy' => 'isSupplementedBy',
        'isPartOf' => 'isPartOf',
        'hasPart' => 'hasPart',
        'isReferencedBy' => 'isReferencedBy',
        'references' => 'references',
        'isIdenticalTo' => 'isIdenticalTo',
        'isDerivedFrom' => 'isDerivedFrom',
        'isSourceOf' => 'isSourceOf',
        'requires' => 'requires',
        'isRequiredBy' => 'isRequiredBy',
      }
      r_map.each do |k, v|
        context k do
          let(:model) { build(:dataset, complex_relation_attributes: [{
            title: 'A relation label',
            url: 'http://example.com/relation',
            relationship: k
          }]) }
          let(:solr_document) { SolrDocument.new(model.to_solr) }
          let(:out) {"
          <jpcoar:relation relationType=\"#{v}\">
            <jpcoar:relatedTitle xml:lang=\"en\">A relation label</jpcoar:relatedTitle>
            <jpcoar:relatedIdentifier identifierType=\"URI\">http://example.com/relation</jpcoar:relatedIdentifier>
          </jpcoar:relation>
        "}
          it "has the xml" do
            solr_document.jpcoar_complex_relation(field, xml)
            expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
          end
        end
      end
    end

    describe 'jpcoar_complex_funding_reference' do
      let(:model) { build(:dataset, :with_complex_funding_reference) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }
      let(:out) {"
        <jpcoar:fundingReference>
          <datacite:funderIdentifier funderIdentifierType=\"Other\">
              f1234
          </datacite:funderIdentifier>
          <jpcoar:funderName xml:lang=\"en\">Bank</jpcoar:funderName>
          <datacite:awardNumber awardURI=\"http://example.com/a1234\">
              a1234
          </datacite:awardNumber>
          <jpcoar:awardTitle xml:lang=\"en\">
              No free lunch
          </jpcoar:awardTitle>
        </jpcoar:fundingReference>
      "}
      it 'has the xml' do
        solr_document.jpcoar_complex_funding_reference(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end
    end

    describe 'jpcoar with Japanese text' do
      let(:model) { build(:dataset, :with_ja) }
      let(:solr_document) { SolrDocument.new(model.to_solr) }

      let(:mo_out) {'
        <jpcoar:contributor contributorType="HostingInstitution">
          <jpcoar:affiliation>
              <jpcoar:affiliationName xml:lang="ja">ナノテクノロジープラットフォーム事業の成果と課題</jpcoar:affiliationName>
          </jpcoar:affiliation>
        </jpcoar:contributor>
      '}
      it 'has the managing organization xml' do
        solr_document.jpcoar_managing_organization(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq mo_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:t_out) {'<dc:title xml:lang="ja">材料データプラットフォームDICE2.0 - データ創出−蓄積−利用−連携の基盤</dc:title>'}
      it 'has the title xml' do
        solr_document.jpcoar_title(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq t_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:at_out) {'<dcterms:alternative xml:lang="ja">試料冷却法を併用したAES深さ方向分析によるSiO2/Si熱酸化膜の分析</dcterms:alternative>'}
      it 'has the alternate_title xml' do
        solr_document.jpcoar_alternate_title(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq at_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:d_out) {'<datacite:description descriptionType="Abstract" xml:lang="ja">わが国の先端共用・技術プラットフォームの 展望と課題を、ナノテクノロジープラットフォーム事業の実績と経験にもとづいて</datacite:description>'}
      it 'has the description xml' do
        solr_document.jpcoar_description(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq d_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:k_out) {'<jpcoar:subject subjectScheme="Other" xml:lang="ja">ナノテクノロジープラットフォーム事業の活動実績</jpcoar:subject>
                    <jpcoar:subject subjectScheme="Other" xml:lang="ja">共用施策設計</jpcoar:subject>'}
      it 'has the keyword xml' do
        solr_document.jpcoar_keyword(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq k_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:p_out) {'<dc:publisher xml:lang="ja">金属材料技術研究所</dc:publisher>'}
      it 'has the xml' do
        solr_document.jpcoar_publisher(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq p_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:au_out) {'
          <jpcoar:creator>
            <jpcoar:familyName xml:lang="ja">田邉 浩介</jpcoar:familyName>
            <jpcoar:givenName xml:lang="ja">江草 由佳</jpcoar:givenName>
            <jpcoar:creatorName xml:lang="ja">轟 眞市</jpcoar:creatorName>
            <jpcoar:nameIdentifier nameIdentifierScheme="ORCID" nameIdentifierURI="23542345234">23542345234</jpcoar:nameIdentifier>
            <jpcoar:affiliation>
              <jpcoar:affiliationName xml:lang="ja">筑波大学</jpcoar:affiliationName>
            </jpcoar:affiliation>
          </jpcoar:creator>
        '}
      it 'has the xml' do
        solr_document.jpcoar_complex_person(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq au_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:src_out) {'
        <jpcoar:sourceTitle xml:lang="ja">統合データベース</jpcoar:sourceTitle>
        <jpcoar:sourceIdentifier identifierType="ISSN">1234-5678</jpcoar:sourceIdentifier>
        <jpcoar:volume>3</jpcoar:volume>
        <jpcoar:issue>34</jpcoar:issue>
        <jpcoar:pageStart>4</jpcoar:pageStart>
        <jpcoar:pageEnd>12</jpcoar:pageEnd>
        <jpcoar:numPages>8</jpcoar:numPages>
      '}
      it 'has the xml' do
        solr_document.jpcoar_complex_source(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq src_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:ev_out) {'
        <jpcoar:conference>
          <jpcoar:conferenceName xml:lang="ja">電子情報通信学会サービスコンピューティング研究会　2019年度第一回研究会、 第４３回MaDIS研究交流会合同研究会</jpcoar:conferenceName>
          <jpcoar:conferencePlace xml:lang="ja">トリプル</jpcoar:conferencePlace>
          <jpcoar:conferenceDate xml:lang="en" startDay="31" startMonth="5" startYear="2019" endDay="1" endMonth="6" endYear="2019">2019-05-31 to 2019-06-01</jpcoar:conferenceDate>
        </jpcoar:conference>
      '}
      it 'has the xml' do
        solr_document.jpcoar_complex_event(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq ev_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:r_out) {'
          <jpcoar:relation relationType="isVersionOf">
            <jpcoar:relatedTitle xml:lang="ja">材料データプラットフォームDICE2.0 - データ創出−蓄積−利用−連携の基盤</jpcoar:relatedTitle>
            <jpcoar:relatedIdentifier identifierType="URI">http://example.com/relation</jpcoar:relatedIdentifier>
          </jpcoar:relation>
        '}
      it "has the xml" do
        solr_document.jpcoar_complex_relation(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq r_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

      let(:f_out) {"
        <jpcoar:fundingReference>
          <datacite:funderIdentifier funderIdentifierType=\"Other\">
              f1234
          </datacite:funderIdentifier>
          <jpcoar:funderName xml:lang=\"ja\">無機材質研究所</jpcoar:funderName>
          <datacite:awardNumber awardURI=\"http://example.com/a1234\">
              a1234
          </datacite:awardNumber>
          <jpcoar:awardTitle xml:lang=\"ja\">
              第2回 SPring-8データワークショップ「SPring-8データセンター構想とMDXプロジェクトとの連携
          </jpcoar:awardTitle>
        </jpcoar:fundingReference>
      "}
      it 'has the xml' do
        solr_document.jpcoar_complex_funding_reference(field, xml)
        expect(xml.target!.gsub(/<to_s\/>/, '')).to eq f_out.split("\n").map(&:rstrip).map(&:lstrip).join("")
      end

    end

  end
end
