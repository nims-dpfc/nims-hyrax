module OrderedFields
  extend ActiveSupport::Concern
  def keyword_ordered=(value)
    r = value.map.with_index { |v, i| "#{i} ~ #{v}" }
    self.keyword = r.sort unless self.keyword.sort == r.sort
  end

  def keyword_ordered
    r = self.keyword
    r.sort.map { |v| v.split("~ ").last }
  end

  def managing_organization_ordered=(value)
    r = value.map.with_index { |v, i| "#{i} ~ #{v}" }
    self.managing_organization = r.sort unless self.managing_organization.sort == r.sort
  end

  def managing_organization_ordered
    r = self.managing_organization
    r.sort.map { |v| v.split("~ ").last }
  end

  def specimen_set_ordered=(value)
    r = value.map.with_index { |v, i| "#{i} ~ #{v}" }
    self.specimen_set = r.sort unless self.specimen_set.sort == r.sort
  end

  def specimen_set_ordered
    r = self.specimen_set
    r.sort.map { |v| v.split("~ ").last }
  end

  # unordered people go to the bottom
  def complex_person_ordered
    @complex_person_ordered ||= self.complex_person.sort_by { |c| c.display_order&.first&.to_i || 500 }
  end

end

# Implementation checklist
# need to change form to use _ordered version
# need to change indexer
# need to change model.en.yml
# if multiple add to form_metadata_service
