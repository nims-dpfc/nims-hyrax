class IndexQaLocalAuthorityEntriesOnLowerLabel < ActiveRecord::Migration[5.1]

  # ActiveRecord doesn't support functional indexes, so we need to add this the old fashioned way. Note the different
  # syntax for sqlite vs postgres
  def up
    if ActiveRecord::Base.connection.adapter_name.downcase.start_with? 'sqlite'
      execute 'CREATE INDEX "index_qa_local_authority_entries_on_lower_label" ON "qa_local_authority_entries" (local_authority_id, label collate nocase);'
    else
      execute 'CREATE INDEX "index_qa_local_authority_entries_on_lower_label" ON "qa_local_authority_entries" (local_authority_id, lower(label));'
    end
  end

  def down
    execute "DROP INDEX index_qa_local_authority_entries_on_lower_label;"
  end
end
