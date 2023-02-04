class QaSelectServiceExtended < Hyrax::QaSelectService
  def find_by_id_or_label(term, &block)
    a = authority.all.select { |e| (e[:label] == term || e[:id] == term) && e[:active] == true }
    if a.any?
      a.first
    else
      {}
    end
  end

  def find_by_id(term, &block)
    a = authority.all.select { |e| e[:id] == term && e[:active] == true }
    if a.any?
      a.first
    else
      {}
    end
  end

  def find_by_label(term, &block)
    a = authority.all.select { |e| e[:label] == term && e[:active] == true }
    if a.any?
      a.first
    else
      {}
    end
  end

  def find_any_by_id(term, &block)
    a = authority.all.select { |e| e[:id] == term }
    if a.any?
      a.first
    else
      {}
    end
  end

end
