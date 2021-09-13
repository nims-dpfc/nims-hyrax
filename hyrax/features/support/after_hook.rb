After do |scenario|
  begin
    Dataset.destroy_all if ENV['RAILS_ENV'] == 'test'
  rescue
    next
  end
end
