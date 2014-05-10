#--encoding=UTF-8

class SummaryController < ApplicationController
	include SummaryHelper
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
	  	redirect_to({:controller => 'summary', :action => 'index', :category=>@category, :project_id=>@project.identifier})
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
		SummaryFactory.new()
	end

	def _get_classified_hash
		find_summary_classified_hash()
	end
	def _get_header
		distinct_summary_templates()
	end

	def save(activeItems)
		Rails.logger.info "Save file to databases #{activeItems}"
		activeItems.each do |ai|
			ai.entity.project = @project
			ai.items.each do |item|
				item.summaries = ai.entity
			end

			duplicates = find_summary_duplicate(ai.entity, ai.items)
			if duplicates.blank?
				# save the entity line first
				ai.entity.save!
				# Rails.logger.info "a activity line is saved: #{ai.entity}"
				ai.items.each do |item|
					#Rails.logger.info item.summary_classifieds.id
					item.summaries = ai.entity
					#Rails.logger.info item.summaries.id
					item.save!
				end
			else
				# duplicated, update the first one duplicated
				dup = duplicates[0]
				dup.summary_fields.each do |f|
					ai.items.each do | item|
						if item.summary_classifieds.template.column_name == f.summary_classifieds.template.column_name
							f.body =item.body
							f.save!
						end
					end
				end
			end
		end
	end

	def edit_summary
		init(params)
		redirect_to({:controller => 'summary', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def destory_summary
		init(params)
		ids = params['ids']
		#Rails.logger.info "delete nr id  #{ids}"
		msg = l(:label_reocrd_delete_success)
		fail_msg = nil
		unless ids.blank?
	
			ids.each do |e|
				begin
					summary = Summary.find(:first, :conditions=>{:id=>e})
					if not summary.blank?
						existed_image = Image.find(:first, :conditions=>{:url => summary.url, :image_date => summary.image_date})
						if not existed_image.blank?
							Image.destroy(existed_image.id)
						end
					Summary.destroy(e)
					end
				rescue Exception => e 
					Rails.logger.error "delete record failed : #{e.inspect}!!!"
					fail_msg =  l(:label_reocrd_delete_fail)
				end
			
			end
			_save_news_event("删除汇总数据","删除汇总数据", "删除汇总数据")
		end
		if fail_msg.blank?
			respond_to do |format|
			  format.html {
				flash[:notice] = msg
				redirect_to({:controller => 'summary', :action => 'index', :category=>@category, :project_id=>@project.identifier, :page=>params[:page]})
			  }
			end
		else
			respond_to do |format|
			  format.html {
				flash[:error] = fail_msg
				redirect_to({:controller => 'summary', :action => 'index', :category=>@category, :project_id=>@project.identifier, :page=>params[:page]})
			  }
			end
		end
	end


	def destory_allsummary
		init(params)
		#Rails.logger.info "delete nr id  #{ids}"
		msg = l(:label_reocrd_delete_success)
		fail_msg = nil
		summaries=Summary.find(:all, :conditions => {:classified =>@category, :projects_id=>@project})
		begin
			summaries.each do |f|
				existed_image = Image.find(:first, :conditions=>{:url => f.url, :image_date => f.image_date})
				if not existed_image.blank?
					Image.destroy(existed_image.id)
				end
				Summary.destroy(f.id)

			end
		_save_news_event("批量删除汇总数据","批量删除汇总数据", "批量删除汇总数据")
		rescue Exception => e 
				Rails.logger.error "delete record failed : #{e.inspect}!!!"
				fail_msg =  l(:label_reocrd_delete_fail)
		end
		if fail_msg.blank?
			respond_to do |format|
			  format.html {
				flash[:notice] = msg
				redirect_to({:controller => 'summary', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			  }
			end
		else
			respond_to do |format|
			  format.html {
				flash[:error] = fail_msg
				redirect_to({:controller => 'summary', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			  }
			end
		end
		
	end

	def import_single_image
		init(params)
		summary = Summary.find(params[:summary_id])
		if summary.blank?
			raise "summary id not presented!"
		end
		record_data = params[:record].read

		template = Template.find(:first, :conditions=>{:template_type=>"汇总数据类模板", :column_name=>"截图"})
		classified = SummaryClassified.find(:first, :conditions=> {:classified=>summary.classified, :template_id=>template.id})
		image_field = SummaryField.find(:first, :conditions=>{:summaries_id => summary.id, :summary_classifieds_id=> classified.id})

		if image_field.blank?
			image_field = SummaryField.new()
			image_field.summaries = summary
			image_field.summary_classifieds = classified
		end


		# prefix supposed to be the $PJM_HOME
			prefix = File.join File.dirname(__FILE__), "../../"
			# relative path is the file path related to the $PJM_HOME
			relative_path = "/public/upload/#{@project.identifier}/"
			# check foler existence
			folder = File.join prefix, relative_path
			unless File.exists?(folder)
				Dir.mkdir(folder)
			end
		uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
		file_full_name = uuid + '.png'
		full_name = File.join folder,file_full_name
		relative_path = File.join relative_path,file_full_name

		# write full
		IO.binwrite(full_name, record_data)
		
		Rails.logger.info "============save image: #{full_name}!!"
		image_field.body = relative_path
		image_field.save!
		_save_news_event(l(:label_manually_import), l(:label_import_image_file), l(:label_import_image_file))
	    respond_to do |format|
	      format.html {
	        flash[:notice] = l(:notice_successful_create)
	        redirect_to({:controller => 'summary', :action => 'index',  :category=>@category, :project_id=>@project.identifier})
	      }
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
