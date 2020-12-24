namespace :metadata do
  desc 'Run all p3 migration tasks'
  task :p3 => [:environment] do
    errors = []
    progress = ProgressBar.create(total: Dataset.count)
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
            if complex_person.role.match(/contact person/i)
              work.complex_person_attributes = [complex_person.attributes.merge("contact_person" => ["0"])]
            end
          end

          # Published date (row 24)
          if work.published_date.blank?
            work.complex_date.each do |complex_date|
              next unless ['Published', 'Issued'].include?(complex_date.type)
              work.published_date << complex_date.date
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
            if complex_person.role.match(/contact person/i)
              work.complex_person_attributes = [complex_person.attributes.merge("contact_person" => ["0"])]
            end
          end

          # Published date (row 24)
          if work.published_date.blank?
            work.complex_date.each do |complex_date|
              next unless ['Published', 'Issued'].include?(complex_date.type)
              work.published_date << complex_date.date
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

    File.write('import_errors.json', errors.to_json)
    Rails.logger.info "*** All P3 migrations have completed: Error Count #{errors.size} ***"
  end
end
