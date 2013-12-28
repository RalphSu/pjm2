#-- encoding: UTF-8
module WeiboHelper

	def distinct_weibo_classifieds() 
		WeiboClassified.all(:select => "DISTINCT(classified)")

	end

	def find_weibo_classifieds(classified)
		WeiboClassified.find(:all, :conditions => {:classified =>classified })
	end

	def distinct_weibo_templates()
		Template.find(:all, :conditions => {:template_type =>"微博类模板" })
	end


	def weibo_option_for_select(selected)
		container = []
		container << ["", ""]
		WeiboClassified.all(:select => "DISTINCT(classified)").each do |n|
			container << [n.classified, n.classified]
		end
		options_for_select(container, selected)
	end

	def find_weibo_classified_hash
		# hash of hash  classified => { template_name => WeiboClassified }
		map = {}
		WeiboClassified.all.each  do |f|
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

	def find_field_by_weiboId(weiboId)
		field = WeiboField.find(:all, :conditions=>{:weibos_id=>weiboId})
		if field.blank?
			map = {}
		else
			map = {}
			field.each do |f|
				map[f.weibo_classifieds.id] = f.body
			end
			map
		end
		# Rails.logger.info map
		map
	end

	class WeiboFactory
		def createEntity(classified_name)
			nr  = Weibo.new()
			nr.classified = classified_name
			return nr
		end
		def createField(body, classified)
			field = WeiboField.new()
			field.body = body
			field.weibo_classifieds = classified
			return field
		end
	end

end
