require 'ruby-progressbar'
namespace :ngdr do
  desc 'Run nested metadata migration tasks. Usage: ngdr:migrate_nested_metadata'
  task :migrate_nested_metadata => [:environment] do
    def migrate_crystallographic_structure(work)
      new_structures = []
      work.complex_specimen_type.each do |st|
        st.complex_crystallographic_structure.each do |cs|
          new_cs = {}
          # description = description
          descriptions = cs.description.reject(&:blank?)
          new_cs[:description] = descriptions if descriptions.present?
          # category_vocabulary = complex_identifier[identifier]
          cs.complex_identifier.each do |id|
            val = id.identifier.reject(&:blank?).first
            if val.present?
              new_cs[:category_vocabulary] = [] unless new_cs.include?(:category_vocabulary)
              new_cs[:category_vocabulary] << val
            end
          end
          new_structures << new_cs if new_cs.present?
        end
      end
      new_structures
    end

    errors = []
    bar = {
      format: "%a %b\u{15E7}%i %p%% %t",
      progress_mark: ' ',
      remainder_mark: "\u{FF65}",
    }
    progress = ProgressBar.create(bar.merge(total: Dataset.count))
    Dataset.find_each do |work|
      begin
        modified = false
        # migrate crystallographic structure
        new_structures = migrate_crystallographic_structure(work)
        if new_structures.present?
          work.complex_crystallographic_structure_attributes = new_structures
          modified = true
          puts new_structures
        end
        work.save! if modified
      rescue => e
        errors << {work: work, exception: e.message, backtrace: e.backtrace}
        Rails.logger.error "error migrating work: #{work.id} - #{e.message}"
      ensure
        progress.increment
      end
    end
    puts "Total Error Count: #{errors.size}"
    File.write('migration_errors.json', errors.to_json)
    Rails.logger.info "*** All nested metadata migration have completed: Error Count #{errors.size} ***"
  end
end
