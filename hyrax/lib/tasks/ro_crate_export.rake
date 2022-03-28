
desc "Exports an RO-Crate file usage: rake 'ro_crate_export[WORK-ID, path/to/zipfile]'"
task :"ro_crate_export", [:work_id, :zipfile] => :environment do |task, args|
  unless args.work_id.present? && args.zipfile.present?
    puts "Please profile a valid work-id and the output path to the zipfile: rake 'ro_crate_export[WORK-ID, path/to/zipfile]'"
    puts "e.g.  $ rake 'ro_crate_export[v692t620b, tmp/rocrate-example.zip]'"
    abort
  end

  work = ActiveFedora::Base.find(args.work_id)
  puts "Exporting #{work.title.first} to: #{args.zipfile}"
  ROCrateExportService.new(work).export_as_zip(args.zipfile)
end
