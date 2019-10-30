require 'solr_wrapper/rake_task'
require 'fcrepo_wrapper/rake_task'
require 'active_fedora/rake_support'

SolrWrapper.default_instance_options = {
    verbose: true,
    cloud: false,
    port: ENV['SOLR_TEST_PORT'] || '8985',
    version: '7.7.2', # NB: ideally this should match the version in docker-compose.yml
    download_dir: 'tmp',
    instance_dir: 'tmp/solr-test',

    # collection_config: 'solr/config/',
    # solr_xml: 'solr/config/solrconfig.xml',
    # collection_name: 'hydra-test',
}

FcrepoWrapper.default_instance({
    verbose: true,
    version: '4.7.3', # NB: ideally this should match the version in docker-compose.yml
    instance_dir: 'tmp/fcrepo4-test',
    fcrepo_home_dir: 'tmp/fcrepo4-test/home',
    enable_jms: false,
    download_dir: 'tmp',
    port: ENV['FEDORA_TEST_PORT'] || '8986'
})

def solr
  SolrWrapper.default_instance
end

namespace :test do
  namespace :servers do

    desc "Load the solr options and solr instance"
    task :environment do
      fail "ERROR: must be run with RAILS_ENV=test (currently: #{ENV['RAILS_ENV']})" unless ENV['RAILS_ENV'] == 'test'
      @solr_instance = SolrWrapper.default_instance
    end

    desc 'Starts a test Solr and Fedora instance for running cucumber tests'
    task :start => :environment do

      # clean out any old solr files
      @solr_instance.remove_instance_dir!
      @solr_instance.extract_and_configure

      # start solr
      @solr_instance.start

      # create the core
      @solr_instance.with_collection({name: 'hydra-test', dir: 'solr/config', persist: true}) { }

      # require 'byebug'
      # byebug

      Rake::Task['fcrepo:clean'].invoke
      Rake::Task['fcrepo:start'].invoke

      puts "FEDORA CONFIG:"
      puts ActiveFedora.config.credentials.inspect

      puts "----\nSOLR CONFIG:"
      puts ActiveFedora.solr_config.inspect

    end

    task :stop => :environment do
      Rake::Task['fcrepo:stop'].invoke
      Rake::Task['solr:stop'].invoke
    end
  end
end