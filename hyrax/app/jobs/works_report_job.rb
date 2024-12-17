require 'csv'
class WorksReportJob < Hyrax::ApplicationJob
  def perform(from_date, to_date, work_id: nil)
    if work_id.present?
      work = ActiveFedora::Base.find(work_id)
      prepare_data(work, from_date, to_date)
    else
      Publication.search_in_batches(public_work) {|doc_set| doc_set.each { |work| prepare_data(work, from_date, to_date)}}
      Dataset.search_in_batches(public_work){|doc_set| doc_set.each { |work| prepare_data(work, from_date, to_date)}}
    end
  end


  def prepare_data(work, from_date, to_date)
    work = work.to_solr unless work.is_a?(Hash)
    start_date = Date.strptime(from_date, "%Y-%m")
    end_date = Date.strptime(to_date, "%Y-%m")
    current_date = start_date

    while current_date <= end_date
      year = current_date.year
      month = current_date.month

      prepare_csv(work, year, month)

      current_date = current_date.next_month
    end
  end

  def prepare_csv(work, year, month)
    work_type = work["has_model_ssim"][0].downcase
    start_date_of_month = Date.new(year, month)
    end_date_of_month = start_date_of_month.end_of_month
    file_path = "/shared/downloads/#{work_type}/#{work_type[..2]}_#{work["id"]}_#{year}_#{month}.csv"

    directory = File.dirname(file_path)
    unless Dir.exist?(directory)
      FileUtils.mkdir_p(directory)
    end
    unless File.exist?(file_path)
      CSV.open(file_path, "w+", write_headers: true, headers: csv_header) do |row|
        authors = work["complex_person_tesim"].present? ? work["complex_person_tesim"].join('|') : ""
        publishers = work['publisher_tesim'].present? ? work['publisher_tesim'].join(",") : ""
        work_uri = "#{ENV.fetch("CAS_BASE_URL")}concern/#{work_type.pluralize}/#{work['id']}"
        publish_year = work["date_published_tesim"].present? ? Date.strptime(work["date_published_tesim"][0], "%d/%m/%Y").year : "0001"
        total_events = Hyrax::Analytics.total_events_for_id(work['id'], "work-view", "#{start_date_of_month.strftime("%d/%m/%Y")},#{end_date_of_month.strftime("%d/%m/%Y")}")
        total_downloads = Hyrax::Analytics.total_events_for_id(work['id'], "file-set-in-work-download", "#{start_date_of_month.strftime("%d/%m/%Y")},#{end_date_of_month.strftime("%d/%m/%Y")}")

        data_row = [work['id'],
                    publishers,
                    authors,
                    work["date_published_tesim"][0] || "",
                    work["manuscript_type_tesim"] || "",
                    work["doi_tesim"] || "",
                    work['id'],
                    "",
                    "",
                    "",
                    work_uri,
                    work["title_tesim"][0],
                    work["resource_type_tesim"][0],
                    publish_year,
                    "Open",
                    "Regular",
                    total_events,
                    total_downloads,
                    "#{month}-#{year}"]
        row << data_row
      end
    end
  end

  def csv_header
    ["Item", "Publisher", "Authors", "Publication_Date", "Article_Version", "DOI", "Proprietary_ID", "ISBN", "Print_ISSN", "Online_ISSN", "URI", "Title", "Data_Type", "YOP", "Access_Type", "Access_Method", "Total_Item_Requests", "Total_Downloads_For_Item", "Reporting period"]
  end

  def public_work
    { workflow_state_name_ssim: "deposited", read_access_group_ssim: "public" }
  end
end