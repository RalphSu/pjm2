#-- encoding: UTF-8

class WeixinController < ApplicationController
	include WeixinHelper
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
	  	redirect_to({:controller => 'weixin', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def _import(file_name, data)
		if  @import_type.blank? || (@import_type == '0')
			# read text
			headers = _get_header()
			poiReader = PoiExcelReader.new(_get_classified_hash, _get_factory)
		  	uploadItems = poiReader.read_excel_text(file_name, headers)
		  	save(uploadItems)
	  	else 
			# read image
	  		poiReader = PoiExcelImageReader.new(@project)
	  		uploadImages = poiReader.read_excel_image(data)
	  		save_images(uploadImages)
	  	end
	end

	def _get_factory
		WeixinFactory.new()
	end

	def _get_classified_hash
		find_weixin_classified_hash()
	end
	def _get_header
		distinct_weixin_templates()
	end

	def save(activeItems)
		Rails.logger.info "Save file to databases #{activeItems}"
		activeItems.each do |ai|
			ai.entity.project = @project
			ai.items.each do |item|
				item.weixins = ai.entity
			end

			duplicates = find_weixin_duplicate(ai.entity, ai.items)
			if duplicates.blank?
				# save the entity line first
				ai.entity.save!
				# Rails.logger.info "a activity line is saved: #{ai.entity}"
				ai.items.each do |item|
					#Rails.logger.info item.weixin_classifieds.id
					item.weixins = ai.entity
					#Rails.logger.info item.weixins.id
					item.save!
				end
			else
				# duplicated, update the first one duplicated
				dup = duplicates[0]
				dup.weixin_fields.each do |f|
					ai.items.each do | item|
						if item.weixin_classifieds.template.column_name == f.weixin_classifieds.template.column_name
							f.body =item.body
							f.save!
						end
					end
				end
			end
		end
	end

	def edit_weixin
		init(params)
		redirect_to({:controller => 'weixin', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def destory_weixin
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
				Weixin.destroy(ids_int)
			rescue Exception => e 
				Rails.logger.error "delete record failed : #{e.inspect}!!!"
				fail_msg =  l(:label_reocrd_delete_fail)
			end
		end
		if fail_msg.blank?
			respond_to do |format|
			  format.html {
				flash[:notice] = msg
				redirect_to({:controller => 'weixin', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			  }
			end
		else
			respond_to do |format|
			  format.html {
				flash[:error] = fail_msg
				redirect_to({:controller => 'weixin', :action => 'index', :category=>@category, :project_id=>@project.identifier})
			  }
			end
		end
	end

	def import_single_image
		init(params)
		weixin = Weixin.find(params[:weixin_id])
		if weixin.blank?
			raise "weixin id not presented!"
		end
		record_data = params[:record].read

		template = Template.find(:first, :conditions=>{:template_type=>"微信类模板", :column_name=>"截图"})
		classified = WeixinClassified.find(:first, :conditions=> {:classified=>weixin.classified, :template_id=>template.id})
		image_field =WeixinField.find(:first, :conditions=>{:weixins_id => weixin.id, :weixin_classifieds_id=> classified.id})

		if image_field.blank?
			image_field = WeixinField.new()
			image_field.weixins = weixin
			image_field.weixin_classifieds = classified
		end

		folder = File.join File.dirname(__FILE__), "../../upload/#{@project.identifier}/"
		unless File.exists?(folder)
				Dir.mkdir(folder)
		end
		uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
		file_full_name = uuid + '.png'
		full_name = File.join folder,file_full_name
		# write full
		IO.binwrite(full_name, record_data)
		
		Rails.logger.info "============save image: #{full_name}!!"
		image_field.body = full_name
		image_field.save!

	    respond_to do |format|
	      format.html {
	        flash[:notice] = l(:notice_successful_create)
	        redirect_to({:controller => 'weixin', :action => 'index',  :category=>@category, :project_id=>@project.identifier})
	      }
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
