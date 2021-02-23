require 'ruby-progressbar'
namespace :metadata do
  desc 'Run all p3 migration tasks'
  task :p3 => [:environment] do
    errors = []
    bar = {
      format: "%a %b\u{15E7}%i %p%% %t",
      progress_mark: ' ',
      remainder_mark: "\u{FF65}",
    }
    progress = ProgressBar.create(bar.merge(total: Dataset.count))
    Dataset.find_each do |work|
      begin
        if work.complex_rights.present? && work.rights_statement.blank?
          # Complex Rights (rows 7 & 8)
          work.complex_rights.each do |complex_right|
            work.rights_statement += complex_right.rights
            work.licensed_date = complex_right.date.first if work.licensed_date.blank?
          end

          # Resource Type (row 9)
          work.resource_type << 'Dataset' unless work.resource_type.present?

          # Contact Person (row 23)
          work.complex_person.each do |complex_person|
            if complex_person.role.detect { |r| r.match(/contact person/i) }
              work.complex_person_attributes = [complex_person.attributes.merge("contact_person" => ["1"])]
            end
          end

          # Published date (row 24)
          if work.date_published.blank?
            work.complex_date.each do |complex_date|
              next unless complex_date.description.detect { |d| d.match(/published|issued/i) }
              work.date_published = complex_date.date.first
            end
          end

          work.save!
        end
      rescue => e
        errors << {work: work, exception: e.message, backtrace: e.backtrace}
        Rails.logger.error "error for work: #{work.id} - #{e.message}"
      ensure
        progress.increment
      end
    end

    puts "Dataset only Error Count: #{errors.size}"
    progress = ProgressBar.create(bar.merge(total: Publication.count))
    Publication.find_each do |work|
      begin
        if work.complex_rights.present? && work.rights_statement.blank?
          # Complex Rights (rows 7 & 8)
          work.complex_rights.each do |complex_right|
            work.rights_statement += complex_right.rights
            work.licensed_date = complex_right.date.first if work.licensed_date.blank?
          end

          # Resource Type (row 9)
          # N/A

          # Contact Person (row 23)
          work.complex_person.each do |complex_person|
            if complex_person.role.detect { |r| r.match(/contact person/i) }
              work.complex_person_attributes = [complex_person.attributes.merge("contact_person" => ["1"])]
            end
          end

          # Published date (row 24)
          if work.date_published.blank?
            work.complex_date.each do |complex_date|
              next unless complex_date.description.detect { |d| d.match(/published|issued/i) }
              work.date_published = complex_date.date.first
            end
          end
          work.save!
        end
      rescue => e
        errors << {work: work, exception: e.message, backtrace: e.backtrace}
        Rails.logger.error "error for work: #{work.id} - #{e.message}"
      ensure
        progress.increment
      end
    end

    puts "Total Error Count: #{errors.size}"

    File.write('metadata_errors.json', errors.to_json)
    # j = JSON.parse(File.read('metadata_errors.json'))
    # j.map { |p| p['exception'] }
    Rails.logger.info "*** All P3 migrations have completed: Error Count #{errors.size} ***"
  end
end
