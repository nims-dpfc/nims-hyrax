# README
## NIMS Hyrax

The application contains 
* Hyrax version 2.3
* Rails 5.1

Requires:
* redis
* Ruby 2.3.1 - 2.5.3 (as tested)

### Steps to install the application 
1.  Clone this project
2.  [Set up `rbenv`](https://github.com/rbenv/rbenv#installation) for ruby 2.5.3 with `rbenv install 2.5.3`
3.  To install, cd to the `hyrax/` directory and
    ```
    gem install bundler
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