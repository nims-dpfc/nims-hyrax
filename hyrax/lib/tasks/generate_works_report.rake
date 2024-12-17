# To run this task For all works: rake ngdr:generate_works_report:all'[from_date, to_date]'
# To run this task for sigle work : rake ngdr:generate_works_report:for_work'[work_id, from_date, to_date]'
namespace :ngdr do
  namespace :generate_works_report do
    desc "Generating works report"
    task :all, [:from_date, :to_date] => :environment do |task, args|
      abort("Please provide all required data [start_date(yyyy-mm), enad_date(yyyy-mm)]") if (args[:from_date].nil? or args[:to_date].nil?)

      WorksReportJob.perform_later(args[:from_date], args[:to_date])
    end

    task :for_work, [:work_id, :from_date, :to_date] => :environment do |task, args|  
      abort("Please provide all required data [work_id, start_date(yyyy-mm), enad_date(yyyy-mm)]") if (args[:work_id].nil? or args[:from_date].nil? or args[:to_date].nil?)

      WorksReportJob.perform_later(args[:from_date], args[:to_date], work_id: args[:work_id])
    rescue ActiveFedora::ObjectNotFoundError => error
      abort("Object not found with id: (#{args[:work_id]})")
    end
  end
end
