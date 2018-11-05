# README
## NIMS Hyrax

The application contains 
* Hyrax version 2.3
* Rails 5.1
* Ruby version 2.4

### Steps to install the application 
1.  Clone this project 
2.  To install, cd to the directory and
    ```
    Bundle install
    bundle exec rake db:migrate
    ```

### Steps to run the application
* You could use screen to run the different components
    ```
    screen
    ```
    To make it easy to navigate screen, you could add this to your ~/.screenrc file
    ```
    hardstatus alwayslastline "%H %-Lw%{= BW}%50>%n%f* %t%{-}%+Lw%<"
    autodetach on
    ```

*  Start Solr
    ```
    solr_wrapper
    ```
* Start Fedora
    ```
    fcrepo_wrapper
   ```
* Start sidekiq to run the background jobs
    ```
    bundle exec sidekiq
    ```
* Start Rails server
    ```
    bundle exec rails s
    ```

