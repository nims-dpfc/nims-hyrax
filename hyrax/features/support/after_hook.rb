After do |scenario|
  Dataset.destroy_all if ENV['RAILS_ENV'] == 'test'
end
