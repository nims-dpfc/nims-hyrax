class DataModelAnalysis

  require 'fileutils'
  attr_accessor :work_data, :work_nested_vals

  def initialize(base_dir)
    @work_data = []
    @work_nested_vals = {}
    @working_dir = File.join(base_dir, "data_analysis_#{Time.now.strftime("%Y%m%dT%H%M%S")}")
  end

  def run
    get_stats(Publication)
    get_stats(Dataset)
    write_to_csv
  end

  def get_stats(model)
    uninterested_keys = %w[head tail]
    model.all.each do |d|
      vals = { id: d.id }
      d.attributes.each do |k, v|
        next unless v.present?
        vals[k] = v.class
        if v.class == ActiveTriples::Relation
          v_json = JSON.parse(v.to_json)
          if v_json.present?
            if v_json.class == Array
              if v_json.first.class == Hash
                inner_hash = { id: d.id }
                v_json.first.each do |inner_k, inner_v|
                  inner_hash[inner_k] = inner_v.class
                end
                @work_nested_vals[k] ||= []
                @work_nested_vals[k].append(inner_hash)
              else
                vals[k] = v_json.first.class
              end
            else
              vals[k] = v_json.class
            end
          end
        elsif v.class == ActiveTriples::Resource
          inner_hash = { id: d.id }
          v.each do |inner_k, inner_v|
            inner_hash[inner_k] = inner_v.class
          end
          @work_nested_vals[k] ||= []
          @work_nested_vals[k].append(inner_hash)
        end
      end
      @work_data.append(vals)
    end
  end

  def write_to_csv
    to_csv('works.csv', @work_data)
    @work_nested_vals.each do |k, v|
      to_csv("works_#{k}.csv", v)
    end
  end

  private
  def to_csv(csv_filename, csv_hash)
    FileUtils.mkdir_p @working_dir unless Dir.exist?(@working_dir)
    csv_file = File.join(@working_dir, csv_filename)
    # Get all unique keys into an array:
    keys = csv_hash.map(&:keys).inject(&:|)
    CSV.open(csv_file, "wb") do |csv|
      csv << keys
      csv_hash.each do |hash|
        # fetch values at keys location, inserting null if not found.
        csv << hash.values_at(*keys)
      end
    end
  end
  
  def parse_active_triples_relation(work_relation, id)
    v_json = JSON.parse(work_relation.to_json)
    return unless v_json.present?
    if v_json.class == Array
      if v_json.first.class == Hash
        inner_hash = { id: id }
        v_json.first.each do |inner_k, inner_v|
          inner_hash[inner_k] = inner_v.class
        end
        @work_nested_vals[k] ||= []
        @work_nested_vals[k].append(inner_hash)
      else
        vals[k] = v_json.first.class
      end
    else
      vals[k] = v_json.class
    end
  end

end