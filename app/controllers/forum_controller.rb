#-- encoding: UTF-8
class ForumController < ApplicationController
	include ForumHelper
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
		Rails.logger.info "read record size: #{data.size}"

		_import(file_name, data)

	  	remove_tmp_file(file_name)
	  	redirect_to({:controller => 'forum', :action => 'index', :category=>@category, :project_id=>@project.identifier})
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
		ForumFactory.new()
	end

	def _get_classified_hash
		find_forum_classified_hash()
	end
	def _get_header
		distinct_forum_templates()
	end

	def save(activeItems)
		Rails.logger.info "Save file to databases #{activeItems}"
		activeItems.each do |ai|
			ai.entity.project = @project
			ai.items.each do |item|
				item.forums = ai.entity
			end

			duplicates = find_forum_duplicate(ai.entity, ai.items)
			if duplicates.blank?
				# save the entity line first
				ai.entity.save!
				#Rails.logger.info "a activity line is saved: #{ai.entity}"
				# now the fields
				ai.items.each do |item|
					#Rails.logger.info item.forum_classifieds.id
					item.forums = ai.entity
					#Rails.logger.info item.forums.id
					item.save!
				end
			else
				# duplicated, update the first one duplicated
				dup = duplicates[0]
				Rails.logger.info "Items are #{ai.items}"
				dup.forum_fields.each do |f|
					ai.items.each do | item|
						if item.forum_classifieds.template.column_name == f.forum_classifieds.template.column_name
							f.body =item.body
							Rails.logger.info " Update from #{f.inspect} to #{item.inspect}"
							f.save!
						end
					end
				end
			end
		end
	end

	def edit_forum
		init(params)
		redirect_to({:controller => 'forum', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def destroy_forum
		init(params)
		ids = params['ids']
		msg = l(:label_reocrd_delete_success)
		fail_msg = nil
		if ids.blank?
			redirect_to({:controller => 'blog', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			return
		end

		unless ids.blank?
			ids.each do |e|
				begin
					forum = Forum.find(:first, :conditions=>{:id=>e})
					if not forum.blank?
						existed_image = Image.find(:first, :conditions=>{:url => forum.url, :image_date => forum.image_date})
						if not existed_image.blank?
							Image.destroy(existed_image.id)
						end
					Forum.destroy(e)
					end
				rescue Exception => e 
					Rails.logger.error "delete record failed : #{e.inspect}!!!"
					fail_msg =  l(:label_reocrd_delete_fail)
				end
			
			end
			_save_news_event("删除论坛数据","删除论坛数据", "删除论坛数据")
		end
		if fail_msg.blank?
			respond_to do |format|
			  format.html {
				flash[:notice] = msg
				redirect_to({:controller => 'forum', :action => 'index', :category=>@category, :project_id=>@project.identifier, :page=>params[:page]})
			  }
			end
		else
			respond_to do |format|
			  format.html {
				flash[:error] = fail_msg
				redirect_to({:controller => 'forum', :action => 'index', :category=>@category, :project_id=>@project.identifier, :page=>params[:page]})
			  }
			end
		end
		
	end



	def destroy_allforum
		init(params)
		#Rails.logger.info "delete nr id  #{ids}"
		msg = l(:label_reocrd_delete_success)
		fail_msg = nil
		forums=Forum.find(:all, :conditions => {:classified =>@category, :project_id=>@project})
		begin
			forums.each do |f|
				existed_image = Image.find(:first, :conditions=>{:url => f.url, :image_date => f.image_date})
				if not existed_image.blank?
					Image.destroy(existed_image.id)
				end
				Forum.destroy(f.id)

			end
		_save_news_event("批量删除论坛数据","批量删除论坛数据", "批量删除论坛数据")
		rescue Exception => e 
				Rails.logger.error "delete record failed : #{e.inspect}!!!"
				fail_msg =  l(:label_reocrd_delete_fail)
		end
		if fail_msg.blank?
			respond_to do |format|
			  format.html {
				flash[:notice] = msg
				redirect_to({:controller => 'forum', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			  }
			end
		else
			respond_to do |format|
			  format.html {
				flash[:error] = fail_msg
				redirect_to({:controller => 'forum', :action => 'index', :category=>@category, :project_id=>@project.identifier})
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
		@link = params[:link]
		@link_date = params[:link_date]
		@page = params[:page]
		@p = @project
		@projects =[]
		@projects << @p unless @p.nil?
	end
end
