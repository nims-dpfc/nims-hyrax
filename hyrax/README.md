# README
## NIMS Hyrax

The application contains 
* Hyrax version 2.3
* Rails 5.1

Requires:
* redis
* Ruby 2.3 - 2.5

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