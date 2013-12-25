#-- encoding: UTF-8

module NewsReleaseHelper

	def news_release_option_for_select(selected)
		container = []
		container << ["", ""]
		NewsClassified.all(:select => "DISTINCT(classified)").each do |n|
			container << [n.classified, n.classified]
		end
		options_for_select(container, selected)
	end

	def find_new_classifieds(classified)
		# select * from news_classified where classified = '@@@'
		NewsClassified.find(:all, :conditions => {:classified =>classified })
	end

	def find_news_classified_hash
		# hash of hash  classified => { template_name => NewsClassified }
		map = {}
		NewsClassified.all.each |f| do
			if map.has_key?(f.classified)
				map[f.classified][f.template.column_name] = f
			else
				inner_map = {}
				inner_map[f.template.column_name] = f
				map[f.classified] = inner_map
			end
		end
		map
	end

	def distinct_news_templates
		Template.find(:all, :conditions => {:template_type =>"新闻类模板" })
	end

	def distinct_news_classifieds
		NewsClassified.all(:select => "DISTINCT(classified)")
	end

	def find_project_release_lines(project)
		project.news_release
	end

	def find_field_by_releaseId_classifiedId(releaseId, classifiedId)
		field = NewsReleaseField.find(:all, :conditions=>{:news_releases_id=>releaseId, :news_classfieds_id=>classifiedId})
		if field.blank?
			''
		else
			field[0].body
		end
	end

end
