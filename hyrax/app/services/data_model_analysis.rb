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
    $stdout.sync = true
    puts "#{Time.now.strftime("%Y-%m-%d T %H:%M:%S")}: #{model.to_s} start"
    model.all.each do |d|
      print "."
      vals = { id: d.id, class: d.class }
      d.attributes.each do |k, v|
        next unless v.present?
        vals[k] = v.class
        if v.class == ActiveTriples::Relation
          parent_new_val = parse_active_triples_relation(d.id, d.class, k, v)
          vals[k] = parent_new_val if parent_new_val.present?
        elsif v.class == ActiveTriples::Resource
          parse_active_resource(d.id, d.class, k, v)
        elsif v.class == Array
          vals[k] = "#{v.class}: #{v.size}"
        end
      end
      @work_data.append(vals)
    end
    puts "#{Time.now.strftime("%Y-%m-%d T %H:%M:%S")}: #{model.to_s} end"
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
  
  def parse_active_triples_relation(work_id, work_class, attribute_name, attr_value)
    relation_data = JSON.parse(attr_value.to_json)
    return unless relation_data.present?
    parent_new_val = nil
    if relation_data.class == Array
      if relation_data.first.class == Hash
        inner_hash = { id: work_id, class: work_class }
        relation_data.first.each do |inner_k, inner_v|
          inner_hash[inner_k] = inner_v.class
          if inner_v.class == ActiveTriples::Relation
            new_inner_val = parse_active_triples_relation(work_id, work_class, inner_k, inner_v)
            inner_hash[inner_k] = new_inner_val if new_inner_val.present?
          elsif inner_v.class == ActiveTriples::Resource
            parse_active_resource(work_id, work_class, inner_k, inner_v)
          elsif inner_v.class == Array
            inner_hash[inner_k] = "#{inner_v.class}: #{inner_v.size}"
          end
        end
        @work_nested_vals[attribute_name] ||= []
        @work_nested_vals[attribute_name].append(inner_hash)
      else
        parent_new_val = relation_data.first.class
      end
    else
      parent_new_val = relation_data.class
    end
    parent_new_val
  end


  def parse_active_resource(work_id, work_class, attribute_name, attr_value)
    inner_hash = { id: work_id, class: work_class }
    attr_value.each do |inner_k, inner_v|
      inner_hash[inner_k] = inner_v.class
      if inner_v.class == Array
        inner_hash[inner_k] = "#{inner_v.class}: #{inner_v.size}"
      end
    end
    @work_nested_vals[attribute_name] ||= []
    @work_nested_vals[attribute_name].append(inner_hash)
  end

end