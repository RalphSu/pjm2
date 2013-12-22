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

	def distinct_news_templates()
		# select * from news_classified where classified = '@@@'
		Template.find(:all, :conditions => {:template_type =>"新闻类模板" })
	end

	def distinct_news_classifieds() 
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
