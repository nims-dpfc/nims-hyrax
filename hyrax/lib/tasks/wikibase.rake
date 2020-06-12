require 'csv'

namespace :wikibase do
  desc 'Fetch Wikibase TSV'
  task :fetch_synonym, ['filename'] => :environment do |task, args|
    Rails.logger.formatter = ::Logger::Formatter.new
    Rails.logger.info("Started Wikibase import task")

    url = ENV.fetch('WIKIBASE_BASE_URL')
    filename = args['filename']
    raise 'Please specify filename.' unless filename

    conn = Faraday.new(url: url) do |req|
      req.use FaradayMiddleware::FollowRedirects
      req.headers['Accept'] = 'application/sparql-results+json'
      req.adapter :net_http
    end

    res = conn.get ENV.fetch('WIKIBASE_SPARQL_QUERY_SYNONYM')

    json = JSON.parse(res.body.force_encoding('UTF-8'))
    File.open(filename, 'wb'){|file|
      json['results']['bindings'].each do |row|
        file.write row['synonyms']['value'].split("\t").to_csv
      end
    }

    Rails.logger.info("Completed Wikibase import task")
  end

  task :reload_solr_core do |task|
    response = Net::HTTP.get_response(URI("http://#{ENV.fetch('SOLR_HOST')}:#{ENV.fetch('SOLR_PORT')}/solr/admin/cores?action=RELOAD&core=#{ENV.fetch('SOLR_CORE')}"))
    if response.message == 'OK'
      puts response.message
    else
      raise 'Failed to reload Solr core'
    end
  end
end
