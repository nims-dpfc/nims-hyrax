# Override FileBasedAuthority class in QA gem v5.6.0 to return all keys
# currently for use in license
# Issue https://github.com/antleaf/nims-mdr-development/issues/574

Qa::Authorities::Local::FileBasedAuthority.class_eval do
  def all
    # not restricting keys to id, term, and active
    terms.each do |res|
      res[:label] = res[:term]
      res[:active] = res.fetch(:active, true)
      res[:uri] = res.fetch(:uri, nil)
    end
  end
end