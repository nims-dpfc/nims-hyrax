# README
## NIMS Hyrax

The application contains 
* Hyrax version 2.3
* Rails 5.1

Requires:
* redis
* Ruby 2.3 - 2.5
* fits

### Set up ruby with `rbenv`
1. Install `rbenv` on your system per the [installation instructions](https://github.com/rbenv/rbenv#installation)
2. Get ruby 2.5.3
    ```
    rbenv install 2.5.3
    ```
3. Install bundler
    ```
    RBENV_VERSION=2.5.3 gem install bundler
    ```

### Characterization
(copied with edits from https://github.com/samvera/hyrax/blob/master/README.md#characterization)
FITS can be installed on OSX using Homebrew by running the command: `brew install fits`

**OR**

1. Go to http://projects.iq.harvard.edu/fits/downloads and download a copy of FITS (see above to pick a known working version) & unpack it somewhere on your machine.
1. Mark fits.sh as executable: `chmod a+x fits.sh`
1. Run `fits.sh -h` from the command line and see a help message to ensure FITS is properly installed
1. Set FITS_PATH in your .env to the installed fits.sh location

### Steps to install the application 
1.  Clone this project
2.  To install, cd to the `hyrax/` directory and
    ```
    bundle install
    bundle exec rake db:migrate
    ```

### Steps to run the application
From the `hyrax/` directory:

*  Start Solr
    ```
    solr_wrapper
    ```
* Start Fedora
    ```
    fcrepo_wrapper
   ```
* Start sidekiq to run the background jobs (requires a running redis instance)
    ```
    bundle exec sidekiq
    ```
* Start Rails server
    ```
    bundle exec rails s
    ```
    
**Note:** You could use screen to run the different components
```
screen
```
To make it easy to navigate screen, you could add this to your ~/.screenrc file
```
hardstatus alwayslastline "%H %-Lw%{= BW}%50>%n%f* %t%{-}%+Lw%<"
autodetach on
```

### Steps to run the tests
When the app is set up, from `hyrax/`:

    bundle exec rspec

for all tests, and e.g.

    bundle exec rspec spec/models/concerns/complex_date_spec.rb
for tests in a specific file.

Before running specs, you will need to setup the test db with the following command:
```
docker-compose exec appdb bash -l -c "createdb -U postges hyrax_test"
```