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
		NewsClassified.all.each  do |f|
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

	def find_news_release_for_project(project, category)
		NewsRelease.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'updated_at desc',:conditions=>{:project_id => project, :classified => category})
	end

	def distinct_news_templates
		Template.find(:all, :conditions => {:template_type =>"新闻类模板" })
	end

	def distinct_news_classifieds
		NewsClassified.all(:select => "DISTINCT(classified)")
	end

	def find_field_by_releaseId(releaseId)
		
		field = NewsReleaseField.find(:all, :conditions=>{:news_releases_id=>releaseId},
			joins: "LEFT JOIN 'images' on images.url=news_release_fields.body",
			select:"news_release_fields.*,images.file_path AS file_path ")

		if field.blank?
			map = {}
		else
			map = {}
			field.each do |f|
				Rails.logger.info f.file_path
				map[f.news_classified.id] = f.body
			end
			map
		end
		# Rails.logger.info map
		map
	end

	class NewsReleaseFactory
		def createEntity(classified_name)
			nr  = NewsRelease.new()
			nr.classified = classified_name
			return nr
		end
		def createField(body, classified)
			field = NewsReleaseField.new()
			field.body = body
			field.news_classified = classified
			return field
		end
	end

end
