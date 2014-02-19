#-- encoding: UTF-8

module WeixinHelper


	def distinct_weixin_classifieds() 
		WeixinClassified.all(:select => "DISTINCT(classified)")

	end

	def find_weixin_classifieds(classified)
		WeixinClassified.find(:all, :conditions => {:classified =>classified })
	end

	def distinct_weixin_templates()
		Template.find(:all, :conditions => {:template_type =>"微信类模板" })
	end

	def find_weixin_for_project(project, category)
		Weixin.paginate(:page=>params[:page]||1,:per_page=>20, :order=>'image_date desc',:conditions=>{:projects_id => project, :classified => category})
	end

	def weixin_option_for_select(selected)
		container = []
		container << ["", ""]
		WeixinClassified.all(:select => "DISTINCT(classified)").each do |n|
			container << [n.classified, n.classified]
		end
		options_for_select(container, selected)
	end

	def find_weixin_classified_hash
		# hash of hash  classified => { template_name => WeixinClassified }
		map = {}
		WeixinClassified.all.each  do |f|
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

	def find_field_by_weixinId(weixinId)
		field = WeixinField.find(:all, :conditions=>{:weixins_id=>weixinId})
			# ,
			# :joins => "LEFT JOIN images on images.url=weixin_fields.body",
			# :select => "weixin_fields.*,images.file_path AS file_path ")
		if field.blank?
			map = {}
		else
			map = {}
			## check image path
			## find date column and link column
			date_field = nil
			link_field = nil
			field.each do |f|
				if f.weixin_classifieds.template.column_name == "日期" and (not f.body.blank?)
					date_field = f
				elsif f.weixin_classifieds.template.column_name == "链接" and (not f.body.blank?)
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
				map[f.weixin_classifieds.id] = f
			end
			map
		end
		# Rails.logger.info map
		map
	end

	class WeixinFactory
		def createEntity(classified_name)
			nr  = Weixin.new()
			nr.classified = classified_name
			return nr
		end
		def createField(body, classified)
			field = WeixinField.new()
			field.body = body
			field.weixin_classifieds = classified
			return field
		end
	end

	def find_weixin_duplicate(nr, fields)
		date = nil
		url = nil
		fields.each do |f|
			if f.weixin_classifieds.template.column_name == '日期'
				date = f
				nr.image_date = date.body
			end
			if f.weixin_classifieds.template.column_name == '链接' 
				url = f
				nr.url = url.body
			end
		end
		Rails.logger.info "-------- check duplicate ------- date: #{date}, url:#{url}.\n Given fields are: #{fields}"
		# check has date and url, then procceed
		if date.nil? or url.nil?
			return nil
		end

		duplicated = Weixin.find(:all, :conditions=>{:classified => nr.classified, :image_date => nr.image_date, :url => nr.url})

		# find_fields = WeixinField.find(:all, :conditions=>["body in (?, ?)", "#{date.body}", "#{url.body}"])

		# duplicated = []
		# find_fields.each do |ff|
		# 	r = ff.weixins
		# 	unless r.blank?
		# 		if r.classified == nr.classified
		# 			date_match = false
		# 			url_match = false
		# 			r.weixin_fields.each do |f|
		# 				if f.weixin_classifieds.template.column_name == '日期' and f.body == date.body
		# 					date_match = true
		# 				end
		# 				if f.weixin_classifieds.template.column_name == '链接' and f.body == url.body
		# 					url_match = true
		# 				end
		# 			end
		# 			if date_match && url_match
		# 				duplicated << r
		# 			end
		# 		end
		# 	end
		# end

		# return duplicated
	end

end
