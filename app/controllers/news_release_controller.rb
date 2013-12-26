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

		headers = _get_header()
		data =  IO.binread(file_name)
		Rails.logger.info "read record size: #{data.size}"
		poiReader = PoiExcelReader.new(_get_classified_hash)
	  	uploadItems = poiReader.read_excel_text(data, headers)

	  	save(uploadItems)

	  	remove_tmp_file(file_name)
	  	redirect_to({:controller => 'news_release', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def _get_classified_hash
		find_news_classified_hash()
	end
	def _get_header()
		distinct_news_templates()
	end

	def save_tmp_file(data)
		file_name = "" + Time.now.inspect + "-" + Random.new().rand().to_s
		full_name = File.join File.dirname(__FILE__),file_name
		Rails.logger.info "Save file with name #{file_name}"
		IO.binwrite(full_name, data)
		full_name
	 end

	 def remove_tmp_file(file_name)
	 	begin
	 		File.delete(file_name)
	 	rescue Exception
	 		Rails.logger.info 'delete temp file failed, ignore and return'
	 	end
	 end

	def save(activeItems)
		Rails.logger.info "Save file to databases #{activeItems}"
		activeItems.each do |ai|
			# save the entity line first
			ai.entity.project = @project
			ai.entity.save
			Rails.logger.info "a activity line is saved: #{ai.entity}"
			ai.entity.reload
			# now the fields
			ai.items.each do |item|
				Rails.logger.info item.news_classified.id
				item.news_classified.reload
				item.news_release = ai.entity
				Rails.logger.info item.news_release.id
				item.save
				item.news_release = ai.entity
				item.save
			end
		end
	end

	def edit_release
		init(params)
		redirect_to({:controller => 'news_release', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def delete_release
		init(params)
		redirect_to({:controller => 'news_release', :action => 'index', :category=>@category, :project_id=>@project.identifier})
	end

	def index
		init(params)
	end

	def init(params)
		@category=params[:category]
		@p = @project
		@projects =[]
		@projects << @p unless @p.nil?
	end
end

