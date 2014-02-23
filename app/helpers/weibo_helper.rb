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

	def find_weibo_for_project(project, category)
		Weibo.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'image_date asc',:conditions=>{:project_id => project, :classified => category})
	end

	def invisible_column()
		columns=["主题","讨论数","排名","位置","热门话题榜","持续天数","活动名称","参加人数"]
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

	def find_weibo_classified(classifedname,columname)
		 aa=find_weibo_classifieds(classifedname)
		 aa.each do |f|
		 	if f.template.column_name==columname
		 		return f
		 	end
		 end

	end

	def find_field_by_weiboId(weiboId)
		field = WeiboField.find(:all, :conditions=>{:weibos_id=>weiboId})
			# ,
			# :joins => "LEFT JOIN images on images.url=weibo_fields.body",
			# :select => "weibo_fields.*,images.file_path AS file_path ")
		if field.blank?
			map = {}
		else
			map = {}
			## check image path
			## find date column and link column
			date_field = nil
			link_field = nil
			field.each do |f|
				if f.weibo_classifieds.template.column_name == "日期" and (not f.body.blank?)
					date_field = f
				elsif f.weibo_classifieds.template.column_name == "链接" and (not f.body.blank?)
					link_field = f
				end
			end
			# find correct _image 
			if (not date_field.blank?) and (not link_field.blank?)
				begin
					date = Date.strptime(date_field.body, "%Y-%m-%d")
					img = Image.find(:first, :conditions=> {:url => link_field.body, :image_date=> date})
					unless img.blank?
						link_field.file_path = img.file_path
					end
				rescue Exception => e
					Rails.logger.info e
				end
			end
			##
			field.each do |f|
				map[f.weibo_classifieds.id] = f
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

	def find_weibo_duplicate(nr, fields)
		date = nil
		url = nil
		# find the field in the given fields
		fields.each do |f|
			if f.weibo_classifieds.template.column_name == '日期'
				date = f
				nr.image_date = date.body
			end
			if f.weibo_classifieds.template.column_name == '链接' 
				url = f
				nr.url = url.body
			end
		end
		Rails.logger.info "-------- check duplicate ------- date: #{date}, url:#{url}.\n"
		# check has date and url, then procceed
		if date.blank? or url.blank?
			return nil
		end

		duplicated = Weibo.find(:all, :conditions=>{:classified => nr.classified, :image_date => nr.image_date, :url => nr.url})
		# find_fields = WeiboField.find(:all, :conditions=>["body in (?, ?)", "#{date.body}", "#{url.body}"])
		# duplicated = []
		# find_fields.each do |ff|
		# 	r = ff.weibos
		# 	# check with the classified
		# 	unless r.blank?
		# 		if r.classified == nr.classified
		# 			date_match = false
		# 			url_match = false
		# 			r.weibo_fields.each do |f|
		# 				if f.weibo_classifieds.template.column_name == '日期' and f.body == date.body
		# 					date_match = true
		# 				end
		# 				if f.weibo_classifieds.template.column_name == '链接' and f.body == url.body
		# 					url_match = true
		# 				end
		# 			end
		# 			if date_match && url_match
		# 				duplicated << r
		# 			end
		# 		end
		# 	end
		# end
		#return duplicated
	end

end
