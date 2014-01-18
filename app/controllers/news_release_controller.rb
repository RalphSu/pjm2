#--encoding=UTF-8

class NewsReleaseController < ApplicationController
	include NewsReleaseHelper
	include ContentsHelper
	layout 'content'

	before_filter :find_project_by_project_id
	
	@show_project_main_menu=false


	def new
		init(params)
	end

	verify :method => :post, :only => :create, :render => {:nothing => true, :status => :method_not_allowed }
	def create
		init(params)

		data = params['record'].read
		file_name = save_tmp_file(data)

		data =  IO.binread(file_name)
		puts "read record size: #{data.size}"

		_import(file_name, data)

	  	remove_tmp_file(file_name)
	  	redirect_to({:controller => 'news_release', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def _import(file_name, data)
		puts "Uploading type : #{@import_type}"
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
	end

	def _get_factory
		NewsReleaseFactory.new()
	end

	def _get_classified_hash
		find_news_classified_hash()
	end
	def _get_header()
		distinct_news_templates()
	end

	def save(activeItems)
		Rails.logger.info "Save file to databases #{activeItems}"
		activeItems.each do |ai|
			# link the entity and the columns
			ai.entity.project = @project
			ai.items.each do |item|
				item.news_release = ai.entity
			end

			duplicates = find_duplicate(ai.entity, ai.items)
			if duplicates.blank?
				# no duplicated, just save
				ai.entity.save!
				Rails.logger.info "a activity line is saved: #{ai.entity}"
				# now the fields
				ai.items.each do |item|
					# Rails.logger.info item.news_classified.id
					item.news_release = ai.entity
					# Rails.logger.info item.news_release.id
					item.save!
				end
			else
				# duplicated, update the first one duplicated
				dup = duplicates[0]
				dup.news_release_fields.each do |f|
					ai.items.each do | item|
						if item.news_classified.template.column_name == f.news_classified.template.column_name
							f.body =item.body
							f.save!
						end
					end
				end
			end
		end
	end

	def edit_release
		init(params)
		redirect_to({:controller => 'news_release', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def delete_release
		
		Rails.logger.info "delete nr id  #{params['ids']}"
		redirect_to({:controller => 'news_release', :action => 'index', :category=>@category, :project_id=>@project.identifier})
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

