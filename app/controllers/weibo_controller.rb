#-- encoding: UTF-8
class WeiboController < ApplicationController
	include WeiboHelper
	include ContentsHelper
	layout 'content'

	before_filter :find_project_by_project_id
	
	@show_project_main_menu=false

	verify :method => :post, :only => :create, :render => {:nothing => true, :status => :method_not_allowed }
	def create
		init(params)

		data = params['record'].read
		file_name = save_tmp_file(data)
		data =  IO.binread(file_name)

		Rails.logger.info "read record size: #{data.size}."
		_import(file_name, data)

	  	remove_tmp_file(file_name)
	  	redirect_to({:controller => 'weibo', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def create_weifantan
		Rails.logger.info "record : #{params['record']}."
		init(params)


		#save entity
	     weibo= Weibo.create! :classified => "微访谈",
                                 :project => @project
           weibo.save!

           

		weibo_data = WeiboField.new()
		weibo_data.weibos=weibo
		weibo_data.weibo_classifieds=find_weibo_classified("微访谈","主题")
		weibo_data.body=params[:subject][:subject]
		weibo_data.save!

		weibo_data2 = WeiboField.new()
		weibo_data2.weibos=weibo
		weibo_data2.weibo_classifieds=find_weibo_classified("微访谈","链接")
		weibo_data2.body=params[:hyperlink][:hyperlink]
		weibo_data2.save!

		weibo_data3 = WeiboField.new()
		weibo_data3.weibos=weibo
		weibo_data3.weibo_classifieds=find_weibo_classified("微访谈","讨论数")
		weibo_data3.body=params[:discussionnumber][:discussionnumber]
		weibo_data3.save!

		weibo_data4 = WeiboField.new()
		weibo_data4.weibos=weibo
		weibo_data4.weibo_classifieds=find_weibo_classified("微访谈","日期")
		weibo_data4.body=params[:wei_date].to_s
		weibo_data4.save!
	  	
		if params['record']
			originalfilename=params['record'].original_filename
			data = params['record'].read
			file_name = save_tmp_file(data)
			data =  IO.binread(file_name)

			Rails.logger.info "create_weihuati read record size: #{data.size}."
			poiReader = PoiExcelImageReader.new(@project)
			imagePath = poiReader.save_pic(data, File.extname(originalfilename),0)
			weibo_data5 = WeiboField.new()
			weibo_data5.weibos=weibo
			weibo_data5.weibo_classifieds=find_weibo_classified("微访谈","图片")
			weibo_data5.body=imagePath
			weibo_data5.save!

			img = Image.new()
			img.url = params[:hyperlink][:hyperlink]
			img.file_path = imagePath
			img.image_date=params[:wei_date]
			img.save!

			remove_tmp_file(file_name)
		end
		_save_news_event("增加微访谈内容","增加微访谈内容", "增加微访谈内容")
	  	redirect_to({:controller => 'weibo', :action => 'index', :category=>@category, :project_id=>@project.identifier})

	end


	def create_weihuati
		Rails.logger.info "record : #{params['record']}."
		init(params)


		#save entity
	     weibo= Weibo.create! :classified => "微话题",
                                 :project => @project
           weibo.save!

           

		weibo_data = WeiboField.new()
		weibo_data.weibos=weibo
		weibo_data.weibo_classifieds=find_weibo_classified("微话题","主题")
		weibo_data.body=params[:subject][:subject]
		weibo_data.save!

		weibo_data2 = WeiboField.new()
		weibo_data2.weibos=weibo
		weibo_data2.weibo_classifieds=find_weibo_classified("微话题","链接")
		weibo_data2.body=params[:hyperlink][:hyperlink]
		weibo_data2.save!

		weibo_data3 = WeiboField.new()
		weibo_data3.weibos=weibo
		weibo_data3.weibo_classifieds=find_weibo_classified("微话题","讨论数")
		weibo_data3.body=params[:discussionnumber][:discussionnumber]
		weibo_data3.save!

		weibo_data4 = WeiboField.new()
		weibo_data4.weibos=weibo
		weibo_data4.weibo_classifieds=find_weibo_classified("微话题","排名")
		weibo_data4.body=params[:order][:order]
		weibo_data4.save!

		weibo_data5 = WeiboField.new()
		weibo_data5.weibos=weibo
		weibo_data5.weibo_classifieds=find_weibo_classified("微话题","位置")
		weibo_data5.body=params[:place][:place]
		weibo_data5.save!

		weibo_data6 = WeiboField.new()
		weibo_data6.weibos=weibo
		weibo_data6.weibo_classifieds=find_weibo_classified("微话题","热门话题榜")
		weibo_data6.body=params[:hottopic][:hottopic]
		weibo_data6.save!
	  	
		weibo_data7 = WeiboField.new()
		weibo_data7.weibos=weibo
		weibo_data7.weibo_classifieds=find_weibo_classified("微话题","持续天数")
		weibo_data7.body=params[:lastdays][:lastdays]
		weibo_data7.save!

		if params['record']
			originalfilename=params['record'].original_filename
			data = params['record'].read
			file_name = save_tmp_file(data)
			data =  IO.binread(file_name)

			Rails.logger.info "create_weihuati read record size: #{data.size}."
			poiReader = PoiExcelImageReader.new(@project)
			imagePath = poiReader.save_pic(data, File.extname(originalfilename),0)
			weibo_data5 = WeiboField.new()
			weibo_data5.weibos=weibo
			weibo_data5.weibo_classifieds=find_weibo_classified("微话题","图片")
			weibo_data5.body=imagePath
			weibo_data5.save!

			img = Image.new()
			img.url = params[:hyperlink][:hyperlink]
			img.file_path = imagePath
			img.save!

			remove_tmp_file(file_name)
		end
		_save_news_event("增加微话题内容","增加微话题内容", "增加微话题内容")
	  	redirect_to({:controller => 'weibo', :action => 'index', :category=>@category, :project_id=>@project.identifier})

	end


	def create_weihuodong
		Rails.logger.info "record : #{params['record']}."
		init(params)


		#save entity
	     weibo= Weibo.create! :classified => "微活动",
                                 :project => @project
           weibo.save!

           

		weibo_data = WeiboField.new()
		weibo_data.weibos=weibo
		weibo_data.weibo_classifieds=find_weibo_classified("微活动","活动名称")
		weibo_data.body=params[:subject][:subject]
		weibo_data.save!

		weibo_data2 = WeiboField.new()
		weibo_data2.weibos=weibo
		weibo_data2.weibo_classifieds=find_weibo_classified("微活动","链接")
		weibo_data2.body=params[:hyperlink][:hyperlink]
		weibo_data2.save!

		weibo_data3 = WeiboField.new()
		weibo_data3.weibos=weibo
		weibo_data3.weibo_classifieds=find_weibo_classified("微活动","参加人数")
		weibo_data3.body=params[:attendeenumber][:attendeenumber]
		weibo_data3.save!

		weibo_data4 = WeiboField.new()
		weibo_data4.weibos=weibo
		weibo_data4.weibo_classifieds=find_weibo_classified("微活动","日期")
		weibo_data4.body=params[:wei_date].to_s
		weibo_data4.save!
	  	
		if params['record']
			originalfilename=params['record'].original_filename
			data = params['record'].read
			file_name = save_tmp_file(data)
			data =  IO.binread(file_name)

			Rails.logger.info "create_weihuati read record size: #{data.size}."
			poiReader = PoiExcelImageReader.new(@project)
			imagePath = poiReader.save_pic(data, File.extname(originalfilename),0)
			weibo_data5 = WeiboField.new()
			weibo_data5.weibos=weibo
			weibo_data5.weibo_classifieds=find_weibo_classified("微活动","图片")
			weibo_data5.body=imagePath
			weibo_data5.save!

			img = Image.new()
			img.url = params[:hyperlink][:hyperlink]
			img.file_path = imagePath
			img.image_date=params[:wei_date]
			img.save!

			remove_tmp_file(file_name)
		end
		_save_news_event("增加微活动内容","增加微活动内容", "增加微活动内容")
	  	redirect_to({:controller => 'weibo', :action => 'index', :category=>@category, :project_id=>@project.identifier})

	end

	def _import(file_name, data)
		if  @import_type.blank? || (@import_type == '0')
			# read text
			headers = _get_header()
			poiReader = PoiExcelReader.new(_get_classified_hash, _get_factory)
		  	uploadItems = poiReader.read_excel_text(file_name, headers)
		  	save(uploadItems)
		  	_save_news_event(l(:label_manually_import), l(:label_import_data_file), l(:label_import_data_file))
	  	else 
			# read image
	  		poiReader = PoiExcelImageReader.new(@project)
	  		uploadImages = poiReader.read_excel_image(data)
	  		save_images(uploadImages)
	  		_save_news_event(l(:label_manually_import), l(:label_import_image_file), l(:label_import_image_file))
	  	end

	  rescue Exception => e
	  	Rails.logger.info e.backtrace.join("\n")
             flash[:error] =  e.message
             
	end

	def _get_factory
		WeiboFactory.new()
	end

	def _get_classified_hash
		find_weibo_classified_hash()
	end
	def _get_header
		distinct_weibo_templates()
	end

	def save(activeItems)
		Rails.logger.info "Save file to databases #{activeItems}"
		activeItems.each do |ai|
			ai.entity.project = @project
			ai.items.each do |item|
				item.weibos = ai.entity
			end

			duplicates = find_weibo_duplicate(ai.entity, ai.items)
			if duplicates.blank?
				# save the entity line first
				ai.entity.save!
				# Rails.logger.info "a activity line is saved: #{ai.entity}"
				ai.items.each do |item|
					#Rails.logger.info item.weibo_classifieds.id
					item.weibos = ai.entity
					#Rails.logger.info item.weibos.id
					item.save!
				end
			else
				# duplicated, update the first one duplicated
				dup = duplicates[0]
				dup.weibo_fields.each do |f|
					ai.items.each do | item|
						if item.weibo_classifieds.template.column_name == f.weibo_classifieds.template.column_name
							f.body =item.body
							f.save!
						end
					end
				end
			end
		end
	end

	def edit_weibo
		init(params)
		redirect_to({:controller => 'weibo', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def destory_weibo
		init(params)
		ids = params['ids']
		#Rails.logger.info "delete nr id  #{ids}"
		msg = l(:label_reocrd_delete_success)
		fail_msg = nil
		unless ids.blank?
			ids_int = []
			ids.each do | id |
				ids_int << id.to_i
			end
			begin
				Weibo.destroy(ids_int)
				_save_news_event("删除微薄数据","删除微薄数据", "删除微薄数据")
			rescue Exception => e 
				Rails.logger.error "delete record failed : #{e.inspect}!!!"
				fail_msg =  l(:label_reocrd_delete_fail)
			end
		end
		if fail_msg.blank?
			respond_to do |format|
			  format.html {
				flash[:notice] = msg
				redirect_to({:controller => 'weibo', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			  }
			end
		else
			respond_to do |format|
			  format.html {
				flash[:error] = fail_msg
				redirect_to({:controller => 'weibo', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			  }
			end
		end
		
	end

	def index
		init(params)
	end

	def init(params)
		@category=params[:category]
		@import_type = params[:import]
		@p = @project
		@projects =[]
		@projects << @p unless @p.nil?
	end
end
