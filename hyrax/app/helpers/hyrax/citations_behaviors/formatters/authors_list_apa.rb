# override - hyrax-2.4.1
module Hyrax
  module CitationsBehaviors
    module Formatters
			module AuthorsListApa

				def format_authors(authors_list = [])
					return '' if authors_list.blank?
					authors_list = Array.wrap(authors_list).collect { |name| abbreviate_name(surname_first(name)).strip }
					# prevent errors if no authors have been specified
					text = ''
					text << authors_list.first if authors_list.first
					authors_list[1..-1].each do |author|
						if author == authors_list.last # last
							text << ", &amp; " << author
						else # all others
							text << ", " << author
						end
					end
					text << "." unless text =~ /\.$/
					text
				end
			end
		end
	end
end