require 'yaml'
require 'cld'

class MdrYamlService
  attr_accessor :mdr_metadata

  NIMS_ROR = "https://ror.org/026v1ze26"

  class CrosswalkException < StandardError
    def initialize(msg="MDR2 Crosswalk Exception")
      super(msg)
    end
  end

  def initialize(work)
    @work = work
    @mdr_metadata = {}
  end

  def yaml_metadata
    map_metadata
    @mdr_metadata.deep_stringify_keys.to_yaml
  end

  def map_metadata
    map_id
    map_titles
    map_identifiers
    map_resource_type
    map_descriptions
    map_subjects
    map_depositor
    map_creators
    map_contact_agents
    map_publisher
    map_date_published_and_state
    map_collections
    map_doi
    map_first_published_url
    map_manuscript_type
    map_visibility
    map_created_at
    map_updated_at
    map_rights
    map_funding
    map_related_item
    map_filesets
    map_thumbnail
    if is_a?(Dataset)
      map_data_origin
      map_managing_organization
      map_instruments
      map_instrument_operator
      map_instrument_managing_org
      map_specimens
      map_chemical_compositions
      map_crystallographic_structures
      map_structural_features
      map_experimental_methods
      map_features
      map_processing
      map_computational_methods
      map_software
      map_energy_levels
      map_custom_property
    end
  end

  private

  def map_id
    @mdr_metadata[:id] = @work.id
  end

  def map_titles
    # titles:
    # - title: PHI surveyスペクトル
    #   title_type: original # 新規追加
    #   lang: ja # 新規追加
    # - title: MIDATA001.104_20200304.spe
    #   title_type: alternative
    #   lang:
    titles = []
    @work.title.each do |t|
      next unless t.present?
      t_hash = {
        title: t,
        lang: get_language_code(t),
        title_type: 'original'
      }
      titles.append(t_hash)
    end
    @work.alternative_title.each do |t|
      next unless t.present?
      t_hash = {
        title: t,
        lang: get_language_code(t),
        title_type: 'alternative'
      }
      titles.append(t_hash)
    end
    @mdr_metadata[:titles] = titles if titles.present?
  end

  def map_identifiers
    # ToDo: Add type of identifier to yaml
    # identifiers:
    # - identifier: DCStag-47912777 # URI形式になっていないものはローカルIDとして扱う
    # - identifier: https://doi.org/10.5555/12345678
    identifiers = []
    @work.complex_identifier.each do |i|
      i_hash = {}
      ids = i.identifier.reject(&:blank?)
      schemes = i.scheme.reject(&:blank?)
      if ids.present?
        i_hash[:identifier] = ids.first
        i_hash[:identifier_type] = schemes.first if schemes.present?
      end
      identifiers.append(i_hash)
    end
    @mdr_metadata[:identifiers] = identifiers if identifiers.present?
  end

  def map_resource_type
    # dataset, article, report, presentation, other のいずれかを取る
    # resource_type: dataset
    resource_type = @work.resource_type.reject(&:blank?)
    case resource_type.first
    when 'Article', 'Dataset', 'Report', 'Presentation'
      @mdr_metadata[:resource_type] = resource_type.first.downcase
    else
      @mdr_metadata[:resource_type] = 'other'
    end
  end

  def map_descriptions
    # descriptions:
    # - description: SAK受入テスト20200316#001-34N～36N # 入力時は必須
    #   lang: ja # ISO-639-1。任意
    descriptions = []
    (@work.description + @work.abstract).each do |d|
      next unless d.present?
      d_hash = {
        description: d,
        lang: get_language_code(d)
      }
      descriptions.append(d_hash)
    end
    @mdr_metadata[:descriptions] = descriptions if descriptions.present?
  end

  def map_subjects
    # ToDo: MDR uses keywords and not subject with schema. I have mapped keyword to subject
    # subjects:
    # - subject: subject1 # 入力時は必須
    #   schema: # 件名のスキーマ。LCSH, NDLSHなど。任意
    subjects = []
    (@work.keyword + @work.subject).each do |s|
      next unless s.present?
      s_hash = {
        subject: s,
        schema: nil
      }
      subjects.append(s_hash)
    end
    @mdr_metadata[:subjects] = subjects if subjects.present?
  end

  def map_depositor
    # depositor: b2a4e5f3-eda4-4946-95f9-9f7d0c108f70
    @mdr_metadata[:depositor] = @work.depositor if @work.depositor.present?
  end

  def map_creators
    # ToDo: have not mapped e_rad, corresponding_author role
    # creators:
    # - name: Example researcher 1 # 必須
    #   orcid:
    #   e_rad: '70409788' # identifier入力時は必須
    #   role: curator # author, editor, translator, depositor, curator, operator. 必須
    #   organization: NIMS # 所属組織
    #   department: DPFC # 所属部署
    #   ror: https://ror.org/026v1ze26
    creators = []
    @work.complex_person_ordered.each do |c|
      role = c.role.reject(&:blank?)
      next if role.include?('contact person')
      person_hash = {}
      # name
      name = c.name.reject(&:blank?)
      if name.present?
        person_hash[:name] = name.first
      else
        person_hash[:name] = (c.first_name + c.last_name).reject(&:blank?).join(' ')
      end
      # orcid
      orcid = c.orcid.reject(&:blank?)
      if orcid.present?
        person_hash[:orcid] = orcid.first
      else
        orcid = []
        c.complex_identifier.each do |i|
          ids = i.identifier.reject(&:blank?)
          schemes = i.scheme.reject(&:blank?)
          orcid.append(ids.first) if ids.present? and schemes.present? and schemes.include?('ORCID')
        end
        person_hash[:orcid] = orcid.first if orcid.present?
      end
      # role
      if role.present? and role.first.present?
        person_hash[:role] = role.first.downcase
      else
        person_hash[:role] = 'author'
      end
      # organization and ror (for NIMS)
      organization = c.organization.reject(&:blank?)
      if organization.present?
        person_hash[:organization] = organization.first
        if organization.first.downcase.strip == "National Institute for Materials Science".downcase
          person_hash[:ror] = NIMS_ROR
        end
      end
      # department
      sub_org = c.sub_organization.reject(&:blank?)
      person_hash[:department] = sub_org.first if sub_org.present?
      # Add person_hash to creators
      creators.append(person_hash)
    end
    @mdr_metadata[:creators] = creators if creators.present?
  end

  def map_contact_agents
    # ToDo: Do I have to hard code organisation and RoR to NIMS
    # contact_agents:
    # - name: Example researcher 3
    #   email: researcher3@nims.example.jp
    #   organization: NIMS # 所属組織
    #   ror: https://ror.org/026v1ze26
    contact_agents = []
    @work.complex_person_ordered.each do |c|
      role = c.role.reject(&:blank?)
      next unless role.include?('contact person')
      contact_agent_hash = {}
      # name
      name = c.name.reject(&:blank?)
      if name.present?
        contact_agent_hash[:name] = name.first
      else
        contact_agent_hash[:name] = (c.first_name + c.last_name).reject(&:blank?).join(' ')
      end
      # email
      email = c.email.reject(&:blank?)
      contact_agent_hash[:email] = email.first if email.present?
      # organization and ror (for NIMS)
      organization = c.organization.reject(&:blank?)
      if organization.present?
        contact_agent_hash[:organization] = organization.first
        if organization.first.downcase.strip == "National Institute for Materials Science".downcase
          contact_agent_hash[:ror] = NIMS_ROR
        end
      end
      # Add person_hash to creators
      contact_agents.append(contact_agent_hash)
    end
    @mdr_metadata[:contact_agents] = contact_agents if contact_agents.present?
  end

  def map_publisher
    # publisher:
    #   organization: NIMS
    #   ror: https://ror.org/026v1ze26
    publisher_hash = {}
    publisher = @work.publisher.reject(&:blank?)
    if publisher.present?
      publisher_hash[:organization] = publisher.first
      if publisher.first.downcase.strip == "National Institute for Materials Science".downcase
        publisher_hash[:ror] = NIMS_ROR
      end
    end
    @mdr_metadata[:publisher] = publisher_hash if publisher_hash.present?
  end

  def map_date_published_and_state
    # date_published: 2021-01-01
    # state: published
    published = false
    if @work.date_published.present?
      date_published = nil
      begin
        date_published = Date.parse(@work.date_published).strftime('%Y-%m-%d')
      rescue
        date_published = @work.date_published
      end
      @mdr_metadata[:date_published] = date_published

      @mdr_metadata[:state] = "published"
      published = true
    else
      #ToDo: Check if this is needed. Published is not in dates.yml
      #@work.complex_date.each do |complex_date|
      #  dt = complex_date.date.reject(&:blank?)
      #  typ = complex_date.description.reject(&:blank?)
      #  if dt.present? and typ.include?('Published')
      #    @mdr_metadata[:date_published] = dt.first
      #    @mdr_metadata[:state] = "published"
      #    published = true
      #  end
      #end
    end
    # ToDo: What should be the state if not published
    # @mdr2_metadata[:state] = "unpublsihed" unless published
  end

  def map_collections
    # collections:
    # - title: サンプル用コレクション
    #   identifier: '12345'
    collections = []
    @work.parent_collections.each do |c|
      col_hash = { identifier: c.id }
      titles = c.title.reject(&:blank?)
      col_hash[:title] = titles.first if titles.present?
      collections.append(col_hash)
    end
    @mdr_metadata[:collections] = collections if collections.present?
  end

  def map_doi
    # doi: 10.5555/12345678
    if @work.doi
      @mdr_metadata[:doi] = @work.doi
    else
      doi = nil
      @work.complex_identifier.each do |i|
        ids = i.identifier.reject(&:blank?)
        schemes = i.scheme.reject(&:blank?)
        doi = ids.first if ids.present? and schemes.present? and schemes.include?('DOI')
      end
      @mdr_metadata[:doi] = doi
    end
  end

  def map_first_published_url
    # first_published_url: https://journal.example.jp
    @mdr_metadata[:first_published_url] = @work.first_published_url if @work.first_published_url
  end

  def map_manuscript_type
    # authors_original,
    # under_review,
    # authors_manuscript,
    # proof,
    # vor (Version of Record)
    # manuscript_type: authors_original
    return unless @work.manuscript_type.present?
    case @work.manuscript_type.downcase.strip
    when 'authors_original', 'under_review', 'authors_manuscript', 'proof'
      @mdr_metadata[:manuscript_type] = @work.manuscript_type.downcase
    when 'vor', 'version of record', 'version'
        @mdr_metadata[:manuscript_type] = 'vor'
    end
  end

  def map_visibility
    # visibility: open_to_public
    # closed, restricted, open_to_public
    # Hyrax options are authenticated, embargo, lease, open, restricted, unknown
    # ToDo: Have I mapped the values correctly?
    # What should the default be? I have gone with closed.
    return unless @work.visibility.present?
    case @work.visibility
    when 'restricted', 'authenticated', 'embargo', 'lease'
      @mdr_metadata[:visibility] = 'restricted'
    when 'open'
      @mdr_metadata[:visibility] = 'open_to_public'
    else
      @mdr_metadata[:visibility] = 'closed'
    end
  end

  def map_created_at
    # created_at: 2021-09-06T15:00:00Z # ISO8601
    @mdr_metadata[:created_at] = @work.create_date.strftime('%Y-%m-%dT%H:%M:%SZ') if @work.create_date
  end

  def map_updated_at
    # updated_at: 2021-09-06T15:00:00Z
    @mdr_metadata[:updated_at] = @work.modified_date.strftime('%Y-%m-%dT%H:%M:%SZ') if @work.modified_date
  end

  def map_rights
    # rights:
    # # descriptionかidentifierのいずれか必須
    # - description: In Copyright
    #   date_licensed: 2021-09-06
    #   condition_of_use: 商用利用の際は連絡すること
    #   # 現行MDRとの互換性のために追加
    #   identifier: http://rightsstatements.org/vocab/InC/1.0/
    # ToDo: Is the mapping below correct?
    mdr_rights = []
    rs = @work.rights_statement.reject(&:blank?)
    service = RightsStatementService.new
    rights_hash = {}
    if rs.present?
      rights_hash[:identifier] = rs.first
      authority_rs = service.find_any_by_id(rs)
      term = authority_rs.fetch(:term, '')
      if term.present?
        rights_hash[:description] = term
      elsif @work.license_description.present?
        rights_hash[:description] = @work.license_description
      end
      rights_hash[:date_licensed] = @work.licensed_date if @work.licensed_date.present?
      mdr_rights.append(rights_hash)
    end
    @work.complex_rights.each do |r|
      dt = r.date.reject(&:blank?)
      rights = r.rights.reject(&:blank?)
      label = r.label.reject(&:blank?)
      if rights.present?
        rights_hash = {}
        rights_hash[:identifier] = rights.first
        rights_hash[:description] = label.first if label.present?
        rights_hash[:date_licensed] = dt.first if dt.present?
        mdr_rights.append(rights_hash)
      end
    end
    @mdr_metadata[:rights] = mdr_rights if mdr_rights.present?
  end

  def map_data_origin
    # data_origins:
    # - data_origin_type: experiment
    data_origins = []
    @work.data_origin.reject(&:blank?).each do |d|
      data_origin_hash = {data_origin_type: d}
      data_origins.append(data_origin_hash)
    end
    @mdr_metadata[:data_origins] = data_origins if data_origins.present?
  end

  def map_managing_organization
    # managing_organization:
    #   ror: https://ror.org/026v1ze26
    #   organization: NIMS
    #   department: 統合型材料開発・情報基盤部門 材料データプラットフォームセンター 材料データ解析グループ
    managing_orgs = []
    # ToDo: I have not mapped department
    #       Should I map managing organization to department and assume NIMS as organization?
    @work.managing_organization.reject(&:blank?).each do |m|
      managing_org_hash = {organization: m}
      if m.downcase.strip == "National Institute for Materials Science".downcase
        managing_org_hash[:ror] = NIMS_ROR
      end
      managing_orgs.append(managing_org_hash)
    end
    @mdr_metadata[:managing_organization] = managing_orgs if managing_orgs.present?
  end

  def map_funding
    # fundings:
    # - identifier: https://kaken.nii.ac.jp/grant/KAKENHI-PROJECT-21K18024/
    #   description: データ駆動型研究のための研究データパッケージング手法の開発
    # ToDo: Check code for description is correct
    fundings = []
    @work.complex_funding_reference.each do |f|
      # Funder identifier
      funder_id = f.funder_identifier.reject(&:blank?).first
      # Funder name
      descriptions = []
      funder_name = f.funder_name.reject(&:blank?).first
      descriptions.append(funder_name) if funder_name.present?
      # Award number
      award_number = f.award_number.reject(&:blank?).first
      descriptions.append("Award number: #{award_number}") if award_number.present?
      # Award title
      award_title = f.award_title.reject(&:blank?).first
      descriptions.append("Award title: #{award_title}") if award_title.present?
      # Funder hash
      funder_hash = {}
      funder_hash[:identifier] = funder_id if funder_id.present?
      funder_hash[:description] = descriptions.join(', ') if descriptions.present?
      fundings.append(funder_hash) if funder_hash.present?
    end
    @mdr_metadata[:fundings] = fundings if fundings.present?
  end

  def map_related_item
    # related_items:
    # - relation_type: is_referenced_by - relationship
    #   identifier: DCStag-47912828 - url
    #   related_item_type: dataset
    # ToDo: Have not mapped related item type. We have title, but not type
    relationships = []
    @work.complex_relation.each do |r|
      # identifier
      identifier = r.url.reject(&:blank?).first
      # relationship
      relationship = r.relationship.reject(&:blank?).first
      related_item_hash = {}
      related_item_hash[:identifier] = identifier if identifier.present?
      related_item_hash[:relation_type] = relationship if relationship.present?
      relationships.append(related_item_hash) if related_item_hash.present?
    end
    @mdr_metadata[:related_items] = relationships if relationships.present?
  end

  def map_filesets
    # NOTE: This is repeated twice in the example yaml file
    # filesets:
    # - filename: example1.txt
    # - filename: example2.png
    # - filename: example3.zip
    fileset_names = []
    @work.file_sets.each do |file_set|
      next unless file_set.original_file.present?
      filename = CGI.unescape(file_set.original_file.file_name.first)
      fileset_names.append({filename: filename}) if filename.present?
    end
    @mdr_metadata[:filesets] = fileset_names if fileset_names.present?
  end

  def map_thumbnail
    # NOTE: This is repeated twice in the example yaml file
    # thumbnail: example2.png
    if @work.thumbnail.present?
      titles = @work.thumbnail.title.reject(&:blank?)
      @mdr_metadata[:thumbnail] = {filename: titles.first} if titles.present?
    end
  end

  def map_instruments
    # instruments:
    # - name: APItestInstrument2 #装置名。入力時は必須
    #   identifier: DCStagid-46401088 # 装置ID
    #   description: 説明2 # 装置説明
    #   function_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q30
    #   function_description:
    #   manufacturer:
    # ToDo: Check the mapping for identifier, function_category and function_description
    instruments = []
    @work.complex_instrument.each do |i|
      instrument_hash = {}
      # name
      names = i.title.reject(&:blank?)
      instrument_hash[:name] = names.first if names.present?
      # identifier
      i.complex_identifier.each do |id|
        ids = id.identifier.reject(&:blank?)
        instrument_hash[:identifier] = ids.first if ids.present?
      end
      # description
      descriptions = i.description.reject(&:blank?)
      instrument_hash[:description] = descriptions.first if descriptions.present?
      # function vocabulary and function description
      i.instrument_function.each do |inst_func|
        categories = inst_func.category.reject(&:blank?)
        instrument_hash[:function_vocabulary] = categories.first if categories.present?
        descriptions = inst_func.description.reject(&:blank?)
        instrument_hash[:function_description] = descriptions.first if descriptions.present?
      end
      # manufacturer
      manufacturers = i.manufacturer.reject(&:blank?)
      instrument_hash[:manufacturer] = manufacturers.first if manufacturers.present?
      instruments.append(instrument_hash) if instrument_hash.present?
    end
    @mdr_metadata[:instruments] = instruments if instruments.present?
  end

  def map_instrument_operator
    # instrument_operators:
    # - name: JAEA Japan Atomic Energy Agency
    operators = []
    @work.complex_instrument_operator.each do |o|
      names = o.name.reject(&:blank?)
      operators.append({name: names.first}) if names.present?
    end
    @work.complex_instrument.each do |c|
      c.complex_person.each do |p|
        name = p.name.reject(&:blank?)
        if name.present?
          operators.append({name: name.first})
        else
          name = (p.first_name + p.last_name).reject(&:blank?).join(' ')
          operators.append({name: name}) if name.present?
        end
      end
    end
    @mdr_metadata[:instrument_operators] = operators if operators.present?
  end

  def map_instrument_managing_org
    # instrument_managing_organizations:
    # - organization: JAEA Japan Atomic Energy Agency
    managing_organizations = []
    @work.complex_instrument.each do |c|
      c.managing_organization.each do |m|
        organization = m.organization.reject(&:blank?)
        managing_organizations.append({organization: organization.first}) if organization.present?
      end
    end
    @mdr_metadata[:instrument_managing_organizations] = managing_organizations if managing_organizations.present?
  end

  def map_specimens
    # specimens:
    # - name: A002 #試料の名前
    #   description: NiO polycrystal film サンプル8 #試料の説明
    #   identifier: DCStagid-47910155 #試料のID
    specimens = []
    @work.complex_specimen_type.each do |s|
      specimen_hash = {}
      # name
      names = s.title.reject(&:blank?)
      specimen_hash[:name] = names.first if names.present?
      # description
      descriptions = s.description.reject(&:blank?)
      specimen_hash[:description] = descriptions.first if descriptions.present?
      # identifier
      s.complex_identifier.each do |id|
        ids = id.identifier.reject(&:blank?)
        specimen_hash[:identifier] = ids.first if ids.present?
      end
      specimens.append(specimen_hash) if specimen_hash.present?
    end
    @mdr_metadata[:specimens] = specimens if specimens.present?
  end

  def map_chemical_compositions
    # chemical_compositions:
    # - identifier: 'PubChem: 23954' #試料の化学組成に関するID
    #   description: TiCoooo #試料の化学組成の説明・記述
    chemical_compositions = []
    @work.complex_chemical_composition.each do |c|
      chemical_composition_hash = map_each_chemical_composition(c)
      chemical_compositions.append(chemical_composition_hash) if chemical_composition_hash.present?
    end
    @work.complex_specimen_type.each do |s|
      s.complex_chemical_composition.each do |c|
        chemical_composition_hash = map_each_chemical_composition(c)
        chemical_compositions.append(chemical_composition_hash) if chemical_composition_hash.present?
      end
    end
    @mdr_metadata[:chemical_compositions] = chemical_compositions if chemical_compositions.present?
  end

  def map_each_chemical_composition(each_composition)
    # chemical_compositions:
    # - identifier: 'PubChem: 23954' #試料の化学組成に関するID
    #   description: TiCoooo #試料の化学組成の説明・記述
    chemical_composition_hash = {}
    # description
    descriptions = each_composition.description.reject(&:blank?)
    chemical_composition_hash[:description] = descriptions.first if descriptions.present?
    # identifier
    each_composition.complex_identifier.each do |id|
      ids = id.identifier.reject(&:blank?)
      chemical_composition_hash[:identifier] = ids.first if ids.present?
    end
    chemical_composition_hash
  end

  def map_crystallographic_structures
    # crystallographic_structures:
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q556 #試料の結晶構造に関するID
    #   description: （試料の結晶構造の説明・記述
    crystallographic_structures = []
    @work.complex_crystallographic_structure.each do |c|
      crystallographic_structure_h = map_each_crystallographic_structure(c)
      crystallographic_structures.append(crystallographic_structure_h) if crystallographic_structure_h.present?
    end
    @work.complex_specimen_type.each do |s|
      s.complex_crystallographic_structure.each do |c|
        crystallographic_structure_h = map_each_crystallographic_structure(c)
        crystallographic_structures.append(crystallographic_structure_h) if crystallographic_structure_h.present?
      end
    end
    @mdr_metadata[:crystallographic_structures] = crystallographic_structures if crystallographic_structures.present?
  end

  def map_each_crystallographic_structure(each_structure)
    # crystallographic_structures:
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q556 #試料の結晶構造に関するID
    #   description: （試料の結晶構造の説明・記述）
    structure_hash = {}
    # category_vocabulary
    category_vocabulary = each_structure.category_vocabulary.reject(&:blank?)
    structure_hash[:category_vocabulary] = category_vocabulary.first if category_vocabulary.present?
    # description
    descriptions = each_structure.description.reject(&:blank?)
    structure_hash[:description] = descriptions.first if descriptions.present?
    # return
    structure_hash
  end

  def map_structural_features
    # structural_features:
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q639 #試料の構造的特徴の分類
    #   description: （試料の構造的特徴の説明・記述
    structural_features = []
    @work.complex_structural_feature.each do |c|
      structural_feature_hash = map_each_structural_features(c)
      structural_features.append(structural_feature_hash) if structural_feature_hash.present?
    end
    @work.complex_specimen_type.each do |s|
      s.complex_structural_feature.each do |c|
        structural_feature_hash = map_each_structural_features(c)
        structural_features.append(structural_feature_hash) if structural_feature_hash.present?
      end
    end
    @mdr_metadata[:structural_features] = structural_features if structural_features.present?
  end

  def map_each_structural_features(each_feature)
    # structural_features:
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q639 #試料の構造的特徴の分類
    #   description: （試料の構造的特徴の説明・記述
    feature_hash = {}
    # category_vocabulary
    category_vocabulary = each_feature.category.reject(&:blank?)
    feature_hash[:category_vocabulary] = category_vocabulary.first if category_vocabulary.present?
    # description
    descriptions = each_feature.description.reject(&:blank?)
    feature_hash[:description] = descriptions.first if descriptions.present?
    # return
    feature_hash
  end

  def map_experimental_methods
    # experimental_methods:
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q31 # 計測法カテゴリー
    #   category_description: spectroscopy -- x-ray absorption spectroscopy
    #   description: 受け入れテスト20200304case3 # 標準手順？ 付記事項？
    experimental_methods = []
    @work.complex_experimental_method.each do |em|
      method_hash = {}
      # category_vocabulary
      category_vocabulary = em.category_vocabulary.reject(&:blank?)
      method_hash[:category_vocabulary] = category_vocabulary.first if category_vocabulary.present?
      # category_description
      category_descriptions = em.category_description.reject(&:blank?)
      method_hash[:category_description] = category_descriptions.first if category_descriptions.present?
      # description
      descriptions = em.description.reject(&:blank?)
      method_hash[:description] = descriptions.first if descriptions.present?
      experimental_methods.append(method_hash) if method_hash.present?
    end
    @mdr_metadata[:experimental_methods] = experimental_methods if experimental_methods.present?
  end

  def map_features
    # features:
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q18 # Excelに記述なし
    #   description: 圧力 / パスカル # Excelに記述なし
    #   value: '10'
    features = []
    @work.complex_feature.each do |cf|
      feature_hash = {}
      # category_vocabulary
      category_vocabulary = cf.category_vocabulary.reject(&:blank?)
      feature_hash[:category_vocabulary] = category_vocabulary.first if category_vocabulary.present?
      # description
      descriptions = cf.description.reject(&:blank?)
      feature_hash[:description] = descriptions.first if descriptions.present?
      features.append(feature_hash) if feature_hash.present?
      # value
      values = cf.value.reject(&:blank?)
      feature_hash[:value] = values.first if values.present?
      features.append(feature_hash) if feature_hash.present?
    end
    @mdr_metadata[:features] = features if features.present?
  end

  def map_processing
    # processing: # 単複同形であることに注意
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q29
    #   description: プロセス名
    #   processed_at: 2015-11-04T15:00:00Z # 処理年月日
    #   processing_environment_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q551 # 処理環境
    #   column_number: 5 # 処理の順番
    # ToDo: check the mappings
    #       I have mapped category_vocabulary, description and column_number from instrument function
    #       I have mapped processed_at from instrument
    # ToDo: I have not mapped processing_environment_vocabulary
    processes = []
    @work.complex_instrument.each do |ci|
      process_hash = {}
      # processed_at - date_collected
      date_collected = ci.date_collected.reject(&:blank?)
      process_hash[:processed_at] = date_collected.first if date_collected.present?
      ci.instrument_function.each do |cif|
        # category_vocabulary
        category_vocabulary = cif.category.reject(&:blank?)
        process_hash[:category_vocabulary] = category_vocabulary.first if category_vocabulary.present?
        # description
        descriptions = cif.description.reject(&:blank?)
        process_hash[:description] = descriptions.first if descriptions.present?
        # column_number
        column_numbers = cif.column_number.reject(&:blank?)
        process_hash[:column_number] = column_numbers.first if column_numbers.present?
      end
      processes.append(process_hash) if process_hash.present?
    end
    @mdr_metadata[:processing] = processes if processes.present?
  end

  def map_computational_methods
    # computational_methods:
    # - category_vocabulary: https://matvoc.nims.go.jp/wiki/Item:Q493
    #   description:
    #   calculated_at: 2015-11-04T15:00:00Z # 計算日
    methods = []
    @work.complex_computational_method.each do |ccm|
      method_hash = {}
      # category_vocabulary
      category_vocabulary = ccm.category_vocabulary.reject(&:blank?)
      method_hash[:category_vocabulary] = category_vocabulary.first if category_vocabulary.present?
      # description
      descriptions = ccm.description.reject(&:blank?)
      method_hash[:description] = descriptions.first if descriptions.present?
      methods.append(method_hash) if method_hash.present?
      # calculated_at
      calculated_at = ccm.calculated_at.reject(&:blank?)
      method_hash[:calculated_at] = calculated_at.first if calculated_at.present?
      methods.append(method_hash) if method_hash.present?
    end
    @mdr_metadata[:computational_methods] = methods if methods.present?
  end

  def map_software
    # software: # ソフトウェア
    # - name: notepad.exe # 新規追加
    #   version: '0.1'
    #   identifier: https://github.com/next-l/enju_leaf
    software = []
    @work.complex_software.each do |cs|
      software_hash = {}
      # name
      names = cs.name.reject(&:blank?)
      software_hash[:name] = names.first if names.present?
      # version
      versions = cs.version.reject(&:blank?)
      software_hash[:version] = versions.first if versions.present?
      methods.append(software_hash) if software_hash.present?
      # identifier
      identifiers = cs.identifier.reject(&:blank?)
      software_hash[:identifier] = identifiers.first if identifiers.present?
      software.append(software_hash) if software_hash.present?
    end
    @mdr_metadata[:software] = software if software.present?
  end

  def map_energy_levels
    # energy_levels: # エネルギー準位・遷移状態
    # - category_vocabulary:
    #   description: La L21-edge
    # ToDo: Which property should this be mapped from?
  end

  def map_custom_property
    # custom_properties: # 独自追加項目
    # - name: 独自項目1
    #   value: 独自の値
    # - name: 独自項目2
    #   value: ABCDE
    #   identifier: https://example.com
    properties = []
    @work.custom_property.each do |cupr|
      names = cupr.label.reject(&:blank?)
      values = cupr.description.reject(&:blank?)
      if names.present? and values.present?
        property_hash = {
          name: names.first,
          value: values.first
        }
        properties.append(property_hash)
      end
      @mdr_metadata[:custom_properties] = properties if properties.present?
    end
  end

  def get_language_code(val)
    lang = CLD.detect_language(val)
    return 'ja' if %w(ja zh-TW zh).include?(lang[:code])
    'en'
  end
end
