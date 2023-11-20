require 'rails_helper'

RSpec.describe ::ComplexFieldsBehavior do
	before do
		class ExampleController < ApplicationController
		  include ComplexFieldsBehavior
		end
	end
	after do
    	Object.send(:remove_const, :ExampleController)
  	end

	it "should remove digit keys" do
	  	@obj = ExampleController.new
	    expect(@obj.send(:cleanup_params, p_with_digit_keys)).to eq p_with_digit_keys_cleaned
	end

	it "should replace nil values with empty strings" do
	  	@obj = ExampleController.new
	    expect(@obj.send(:cleanup_params, p_with_nil_values)).to eq p_with_nil_values_cleaned
	end

	it "should scrub unsafe values" do
	  	@obj = ExampleController.new
	    expect(@obj.send(:cleanup_params, p_with_unsafe_values)).to eq p_with_unsafe_values_cleaned
	end

	it "should remove empty hashes" do
	  	@obj = ExampleController.new
	    expect(@obj.send(:cleanup_params, p_with_empty_hashes)).to eq p_with_empty_hashes_cleaned
	end

	it "should prepare ghost hashes for delete" do
		# This test is to remove empty hashes with ids saved previously because of the bug to be deleted
	  	@obj = ExampleController.new
	    expect(@obj.send(:cleanup_params, p_with_ghost_hashes)).to eq p_with_ghost_hashes_cleaned
	end

	it 'should clean all params received from publication' do
	  	@obj = ExampleController.new
	    expect(@obj.send(:cleanup_params, publication_attributes_from_form)).to eq publication_attributes_from_form_cleaned
	end
end

def p_with_digit_keys
	return {
	 "complex_person_attributes"=>
	  {"0"=>
	    {"last_name"=>["Rang"],
	     "first_name"=>["Anusha"],
	     "name"=>[""],
	     "role"=>["author"],
	     "orcid"=>[""],
	     "organization"=>["test org"],
	     "sub_organization"=>[""],
	     "contact_person"=>"1",
	     "display_order"=>"0",
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#persong47006664005840"}}
	}
end

def p_with_digit_keys_cleaned
	return {
	 "complex_person_attributes"=>
	  [
	    {"last_name"=>["Rang"],
	     "first_name"=>["Anusha"],
	     "name"=>[""],
	     "role"=>["author"],
	     "orcid"=>[""],
	     "organization"=>["test org"],
	     "sub_organization"=>[""],
	     "contact_person"=>"1",
	     "display_order"=>"0",
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#persong47006664005840"}]
	}
end

def p_with_nil_values
	return {
	 "first_published_url"=>nil,
	 "managing_organization_ordered"=>[]
	}
end

def p_with_nil_values_cleaned
	return {
	 "first_published_url"=>'',
	 "managing_organization_ordered"=>[""]
	}
end

def p_with_unsafe_values
	return {
	 "first_published_url"=>'<script>something here</script>',
	 "managing_organization_ordered"=>["<script>", "another thing", ''],
	 "complex_source_attributes"=>
	  {"0"=>
	    {"title"=>["Journal title"],
	     "issn"=>["1111-1111-1111-1111"],
	     "alternative_title"=>["<script>Alt journal title</script>"],
			 "article_number"=>["a1234"],
	     "volume"=>["1"],
	     "issue"=>["23"],
	     "sequence_number"=>["2342"],
	     "start_page"=>["12"],
	     "end_page"=>["32"],
	     "total_number_of_pages"=>["20"],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg69892251809000"}}
	}
end

def p_with_unsafe_values_cleaned
	return {
	 "first_published_url"=>'&lt;script&gt;something here&lt;/script&gt;',
	 "managing_organization_ordered"=>["&lt;script&gt;&lt;/script&gt;", "another thing"],
	 "complex_source_attributes"=>
	    [{"title"=>["Journal title"],
	     "issn"=>["1111-1111-1111-1111"],
	     "alternative_title"=>["&lt;script&gt;Alt journal title&lt;/script&gt;"],
 			 "article_number"=>["a1234"],
	     "volume"=>["1"],
	     "issue"=>["23"],
	     "sequence_number"=>["2342"],
	     "start_page"=>["12"],
	     "end_page"=>["32"],
	     "total_number_of_pages"=>["20"],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg69892251809000"}]
	}
end

def p_with_empty_hashes
	return {
	 "complex_person_attributes"=>
	  {"0"=>
	    {"last_name"=>["Rang"],
	     "first_name"=>["Anusha"],
	     "name"=>[""],
	     "role"=>["author"],
	     "orcid"=>[""],
	     "organization"=>["test org"],
	     "sub_organization"=>[""],
	     "contact_person"=>"1",
	     "display_order"=>"0",
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#persong47006664005840"},
	   "1"=>
	    {"last_name"=>[""],
	     "first_name"=>[""],
	     "name"=>[""],
	     "role"=>[""],
	     "orcid"=>[""],
	     "organization"=>[""],
	     "sub_organization"=>[""],
	     "contact_person"=>"0",
	     "display_order"=>"0",
	     "_destroy"=>"false"}}
	}
end

def p_with_empty_hashes_cleaned
	return {
	 "complex_person_attributes"=>
	  [{"last_name"=>["Rang"],
	    "first_name"=>["Anusha"],
	    "name"=>[""],
	    "role"=>["author"],
	    "orcid"=>[""],
	    "organization"=>["test org"],
	    "sub_organization"=>[""],
	    "contact_person"=>"1",
	    "display_order"=>"0",
	    "_destroy"=>"false",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#persong47006664005840"}]
	}
end

def p_with_ghost_hashes
	return {
	 "complex_source_attributes"=>
	  {"0"=>
	    {"title"=>["Journal title"],
	     "issn"=>["1111-1111-1111-1111"],
	     "alternative_title"=>["Alt journal title"],
			 "article_number"=>["a1234"],
	     "volume"=>["1"],
	     "issue"=>["23"],
	     "sequence_number"=>["2342"],
	     "start_page"=>["12"],
	     "end_page"=>["32"],
	     "total_number_of_pages"=>["20"],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg69892251809000"},
	   "1"=>
	    {"title"=>[""],
	     "issn"=>[""],
	     "alternative_title"=>[""],
			 "article_number"=>[""],
	     "volume"=>[""],
	     "issue"=>[""],
	     "sequence_number"=>[""],
	     "start_page"=>[""],
	     "end_page"=>[""],
	     "total_number_of_pages"=>[""],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47324997176140"},
	   "2"=>
	    {"title"=>[""],
	     "issn"=>[""],
	     "alternative_title"=>[""],
			 "article_number"=>[""],
	     "volume"=>[""],
	     "issue"=>[""],
	     "sequence_number"=>[""],
	     "start_page"=>[""],
	     "end_page"=>[""],
	     "total_number_of_pages"=>[""],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47325006725260"},
	   "3"=>
	    {"title"=>[""],
	     "issn"=>[""],
	     "alternative_title"=>[""],
			 "article_number"=>[""],
	     "volume"=>[""],
	     "issue"=>[""],
	     "sequence_number"=>[""],
	     "start_page"=>[""],
	     "end_page"=>[""],
	     "total_number_of_pages"=>[""],
	     "_destroy"=>"false"}}
	}
end

def p_with_ghost_hashes_cleaned
	return {
	 "complex_source_attributes"=>
	  [{"title"=>["Journal title"],
	    "issn"=>["1111-1111-1111-1111"],
	    "alternative_title"=>["Alt journal title"],
			"article_number"=>["a1234"],
	    "volume"=>["1"],
	    "issue"=>["23"],
	    "sequence_number"=>["2342"],
	    "start_page"=>["12"],
	    "end_page"=>["32"],
	    "total_number_of_pages"=>["20"],
	    "_destroy"=>"false",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg69892251809000"},
	   {"title"=>["Dummy text"],
	    "issn"=>[""],
	    "alternative_title"=>[""],
			"article_number"=>[""],
	    "volume"=>[""],
	    "issue"=>[""],
	    "sequence_number"=>[""],
	    "start_page"=>[""],
	    "end_page"=>[""],
	    "total_number_of_pages"=>[""],
	    "_destroy"=>"true",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47324997176140"},
	   {"title"=>["Dummy text"],
	    "issn"=>[""],
	    "alternative_title"=>[""],
			"article_number"=>[""],
	    "volume"=>[""],
	    "issue"=>[""],
	    "sequence_number"=>[""],
	    "start_page"=>[""],
	    "end_page"=>[""],
	    "total_number_of_pages"=>[""],
	    "_destroy"=>"true",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47325006725260"}]
	}
end


def publication_attributes_from_form
	return {
	 "managing_organization_ordered"=>["Library", ""],
	 "first_published_url"=>"https://dx.doi.org/0000-0001",
	 "title"=>["Test publication", ""],
	 "alternative_title"=>"",
	 "resource_type"=>["", "Article"],
	 "description"=>
	  ["This is the abstract for the text work. It sets out the aims of this test record.",
	   ""],
	 "keyword_ordered"=>["test", "blank", ""],
	 "specimen_set_ordered"=>["Workflow notifications", ""],
	 "publisher"=>["CL", ""],
	 "date_published"=>"25/10/2020",
	 "rights_statement"=>["", "https://creativecommons.org/licenses/by/4.0/"],
	 "licensed_date"=>"10/11/2020",
	 "complex_person_attributes"=>
	  {"0"=>
	    {"last_name"=>["Rang"],
	     "first_name"=>["Anusha"],
	     "name"=>[""],
	     "role"=>["author"],
	     "orcid"=>[""],
	     "organization"=>["test org"],
	     "sub_organization"=>[""],
	     "contact_person"=>"1",
	     "display_order"=>"0",
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#persong47006664005840"},
	   "1"=>
	    {"last_name"=>[""],
	     "first_name"=>[""],
	     "name"=>[""],
	     "role"=>[""],
	     "orcid"=>[""],
	     "organization"=>[""],
	     "sub_organization"=>[""],
	     "contact_person"=>"0",
	     "display_order"=>"0",
	     "_destroy"=>"false"}},
	 "complex_source_attributes"=>
	  {"0"=>
	    {"title"=>["Journal title"],
	     "issn"=>["1111-1111-1111-1111"],
	     "alternative_title"=>["Alt journal title"],
			 "article_number"=>["a1234"],
	     "volume"=>["1"],
	     "issue"=>["23"],
	     "sequence_number"=>["2342"],
	     "start_page"=>["12"],
	     "end_page"=>["32"],
	     "total_number_of_pages"=>["20"],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg69892251809000"},
	   "1"=>
	    {"title"=>[""],
	     "issn"=>[""],
	     "alternative_title"=>[""],
			 "article_number"=>[""],
	     "volume"=>[""],
	     "issue"=>[""],
	     "sequence_number"=>[""],
	     "start_page"=>[""],
	     "end_page"=>[""],
	     "total_number_of_pages"=>[""],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47324997176140"},
	   "2"=>
	    {"title"=>[""],
	     "issn"=>[""],
	     "alternative_title"=>[""],
			 "article_number"=>[""],
	     "volume"=>[""],
	     "issue"=>[""],
	     "sequence_number"=>[""],
	     "start_page"=>[""],
	     "end_page"=>[""],
	     "total_number_of_pages"=>[""],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47325006725260"},
	   "3"=>
	    {"title"=>[""],
	     "issn"=>[""],
	     "alternative_title"=>[""],
			 "article_number"=>[""],
	     "volume"=>[""],
	     "issue"=>[""],
	     "sequence_number"=>[""],
	     "start_page"=>[""],
	     "end_page"=>[""],
	     "total_number_of_pages"=>[""],
	     "_destroy"=>"false"}},
	 "manuscript_type"=>"",
	 "complex_event_attributes"=>
	  {"0"=>
	    {"title"=>[""],
	     "place"=>[""],
	     "start_date"=>[""],
	     "end_date"=>[""],
	     "invitation_status"=>["0"],
	     "_destroy"=>"false"}},
	 "language"=>[""],
	 "complex_date_attributes"=>
	  {"0"=>{"description"=>[""], "date"=>[""], "_destroy"=>"false"}},
	 "complex_identifier_attributes"=>
	  {"0"=>
	    {"scheme"=>["identifier local"],
	     "identifier"=>["123534523464"],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#identifierg47006647342460"},
	   "1"=>{"scheme"=>[""], "identifier"=>[""], "_destroy"=>"false"}},
	 "complex_version_attributes"=>
	  {"0"=>{"version"=>[""], "date"=>[""], "_destroy"=>"false"}},
	 "complex_relation_attributes"=>
	  {"0"=>
	    {"title"=>[""],
	     "url"=>[""],
	     "relationship"=>[""],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#relationg69952558454600"},
	   "1"=>
	    {"title"=>[""],
	     "url"=>[""],
	     "relationship"=>[""],
	     "_destroy"=>"false",
	     "id"=>
	      "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#relationg69952538857800"},
	   "2"=>
	    {"title"=>[""], "url"=>[""], "relationship"=>[""], "_destroy"=>"false"}},
	 "custom_property_attributes"=>
	  {"0"=>{"label"=>[""], "description"=>[""], "_destroy"=>"false"}},
	 "admin_set_id"=>"admin_set/default",
	 "member_of_collection_ids"=>"",
	 "find_child_work"=>"",
	 "permissions_attributes"=>
	  {"2"=>
	    {"access"=>"edit",
	     "id"=>
	      "f5e4d054-f4d2-4b7d-a126-a1cd8b9337fb/78/2f/a7/3a/782fa73a-8617-4bc2-92e1-c6d1467c6661"}},
	 "visibility"=>"open",
	 "version"=>"W/\"2cf9baf53ac3e1b6b9e5d4910c2c8ce629fb1d90\""
	}
end

def publication_attributes_from_form_cleaned
	return {
	 "managing_organization_ordered"=>["Library"],
	 "first_published_url"=>"https://dx.doi.org/0000-0001",
	 "title"=>["Test publication"],
	 "alternative_title"=>"",
	 "resource_type"=>["Article"],
	 "description"=>
	  ["This is the abstract for the text work. It sets out the aims of this test record."],
	 "keyword_ordered"=>["test", "blank"],
	 "specimen_set_ordered"=>["Workflow notifications"],
	 "publisher"=>["CL"],
	 "date_published"=>"25/10/2020",
	 "rights_statement"=>["https://creativecommons.org/licenses/by/4.0/"],
	 "licensed_date"=>"10/11/2020",
	 "complex_person_attributes"=>
	  [{"last_name"=>["Rang"],
	    "first_name"=>["Anusha"],
	    "name"=>[""],
	    "role"=>["author"],
	    "orcid"=>[""],
	    "organization"=>["test org"],
	    "sub_organization"=>[""],
	    "contact_person"=>"1",
	    "display_order"=>"0",
	    "_destroy"=>"false",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#persong47006664005840"}],
	 "complex_source_attributes"=>
	  [{"title"=>["Journal title"],
	    "issn"=>["1111-1111-1111-1111"],
	    "alternative_title"=>["Alt journal title"],
			"article_number"=>["a1234"],
	    "volume"=>["1"],
	    "issue"=>["23"],
	    "sequence_number"=>["2342"],
	    "start_page"=>["12"],
	    "end_page"=>["32"],
	    "total_number_of_pages"=>["20"],
	    "_destroy"=>"false",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg69892251809000"},
	   {"title"=>["Dummy text"],
	    "issn"=>[""],
	    "alternative_title"=>[""],
			"article_number"=>[""],
	    "volume"=>[""],
	    "issue"=>[""],
	    "sequence_number"=>[""],
	    "start_page"=>[""],
	    "end_page"=>[""],
	    "total_number_of_pages"=>[""],
	    "_destroy"=>"true",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47324997176140"},
	   {"title"=>["Dummy text"],
	    "issn"=>[""],
	    "alternative_title"=>[""],
			"article_number"=>[""],
	    "volume"=>[""],
	    "issue"=>[""],
	    "sequence_number"=>[""],
	    "start_page"=>[""],
	    "end_page"=>[""],
	    "total_number_of_pages"=>[""],
	    "_destroy"=>"true",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#sourceg47325006725260"}],
	 "manuscript_type"=>"",
	 "complex_event_attributes"=>[],
	 "language"=>[""],
	 "complex_date_attributes"=>[],
	 "complex_identifier_attributes"=>
	  [{"scheme"=>["identifier local"],
	    "identifier"=>["123534523464"],
	    "_destroy"=>"false",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#identifierg47006647342460"}],
	 "complex_version_attributes"=>[],
	 "complex_relation_attributes"=>
	  [{"title"=>["Dummy text"],
	    "url"=>[""],
	    "relationship"=>[""],
	    "_destroy"=>"true",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#relationg69952558454600"},
	   {"title"=>["Dummy text"],
	    "url"=>[""],
	    "relationship"=>[""],
	    "_destroy"=>"true",
	    "id"=>
	     "http://fcrepo:8080/fcrepo/rest/dev/q5/24/jn/76/q524jn76v#relationg69952538857800"}],
	 "custom_property_attributes"=>[],
	 "admin_set_id"=>"admin_set/default",
	 "member_of_collection_ids"=>"",
	 "permissions_attributes"=>
	  {"2"=>
	    {"access"=>"edit",
	     "id"=>
	      "f5e4d054-f4d2-4b7d-a126-a1cd8b9337fb/78/2f/a7/3a/782fa73a-8617-4bc2-92e1-c6d1467c6661"}},
	 "visibility"=>"open",
	 "version"=>"W/\"2cf9baf53ac3e1b6b9e5d4910c2c8ce629fb1d90\""
	}
end
