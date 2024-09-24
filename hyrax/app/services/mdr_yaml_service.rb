require 'yaml'

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
        i_hash[:type] = schemes.first if schemes.present?
      end
      identifiers.append(i_hash)
    end
    doi = @work.doi.reject(&:blank?) if @work.doi.present?
    if doi.present?
      i_hash = {}
      i_hash[:identifier] =  doi.first
      i_hash[:type] = 'DOI'
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
      @mdr_metadata[:resource_type] = resource_type.first
    else
      @mdr_metadata[:resource_type] = 'Other'
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
        identifier: d,
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
        person_hash[:role] = role.first
      else
        person_hash[:role] = 'Creator'
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
    publishers = []
    publisher = @work.publisher.reject(&:blank?)
    if publisher.present?
      publisher_hash = {}
      publisher_hash[:organization] = publisher.first
      if publisher.first.downcase.strip == "National Institute for Materials Science".downcase
        publisher_hash[:ror] = NIMS_ROR
      end
      publishers.append(publisher_hash)
    end
    @mdr_metadata[:publisher] = publishers if publishers.present?
  end

  def map_date_published_and_state
    # date_published: 2021-01-01
    # state: published
    published = false
    if @work.date_published.present?
      @mdr_metadata[:date_published] = @work.date_published
      @mdr_metadata[:state] = "published"
      published = true
    else
      #ToDo: Check if this is needed. Published is not in dates.yml
      @work.complex_date.each do |complex_date|
        dt = complex_date.date.reject(&:blank?)
        typ = complex_date.description.reject(&:blank?)
        if dt.present? and typ.include?('Published')
          @mdr_metadata[:date_published] = dt.first
          @mdr_metadata[:state] = "published"
          published = true
        end
      end
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
    when 'authors_original', 'under_review', 'authors_manuscript', 'proof', 'vor'
      @mdr_metadata[:manuscript_type] = @work.manuscript_type.downcase
    when 'version of record', 'version'
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

  def get_language_code(val)
    lang = CLD.detect_language(val)
    return 'ja' if %w(ja zh-TW zh).include?(lang[:code])
    'en'
  end
end