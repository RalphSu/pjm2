class TemplatesController < ApplicationController
	include TemplatesHelper
	include NewsReleaseHelper
	include BlogHelper
	include WeiboHelper
	include ForumHelper
	include WeixinHelper
	include SummaryHelper
	
	layout 'admin'
	
	def index
		# classifiedName => [column_name]
		@news_field_map ={}
		news_classifieds = distinct_news_classifieds();
		news_classifieds.each do |classified|
			 @news_field_map[classified.classified] = find_new_classifieds(classified.classified).collect do | c |
			 	c.template.column_name
			 end
		end
		@news_field_map

		#blog
		@blog_field_map ={}
		blog_classifieds = distinct_blog_classifieds();
		blog_classifieds.each do |classified|
			 @blog_field_map[classified.classified] = find_blog_classifieds(classified.classified).collect do | c |
			 	c.template.column_name
			 end
		end

		# forum
		@forum_field_map ={}
		forum_classifieds = distinct_forum_classifieds();
		forum_classifieds.each do |classified|
			 @forum_field_map[classified.classified] = find_forum_classifieds(classified.classified).collect do | c |
			 	c.template.column_name
			 end
		end

		# weibo
		@weibo_field_map ={}
		weibo_classifieds = distinct_weibo_classifieds();
		weibo_classifieds.each do |classified|
			 @weibo_field_map[classified.classified] = find_weibo_classifieds(classified.classified).collect do | c |
			 	c.template.column_name
			 end
		end

		# weixin
		@weixin_field_map ={}
		weixin_classifieds = distinct_weixin_classifieds();
		weixin_classifieds.each do |classified|
			 @weixin_field_map[classified.classified] = find_weixin_classifieds(classified.classified).collect do | c |
			 	c.template.column_name
			 end
		end
		


		# summary
		@summary_field_map ={}
		summary_classifieds = distinct_summary_classifieds();
		summary_classifieds.each do |classified|
			 @summary_field_map[classified.classified] = find_summary_classifieds(classified.classified).collect do | c |
			 	c.template.column_name
			 end
		end
	end

	def view_template
		redirect_to({:controller => 'templates', :action => 'index'})
	end


	def new_news
		name = params[:classified_name][:classified_name].strip()
    		columns = params[:columns]
    		Rails.logger.info "name: #{name}, columns #{columns}"
    		if columns
    		     news_classifieds = distinct_news_classifieds();
			news_classifieds.each do |classified|
				if(classified.classified==name)
					respond_to do |format|
					format.html {
						flash[:error] = "Name #{name} already exists"
						redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/news'})
					}
					end
	      			return
	      		end
			end
			news_templates= distinct_news_templates();
			columns.each do |column|
				news_templates.each do |template|
					if(column==template.column_name)
						 newone = NewsClassified.create! :classified => name,
                                 :template => template
     						newone.save!

					end

				end
    			end
			
    			respond_to do |format|
			format.html {
				flash[:notice] = l(:notice_successful_update)
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/news'})
			}
	      	end
    		else
    			respond_to do |format|
			format.html {
				flash[:notice] = "No Column selected"
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/news'})
			}
	      	end
    		end

    	
	end


	def new_weibo
		name = params[:classified_name][:classified_name].strip()
    		columns = params[:columns]
    		Rails.logger.info "name: #{name}, columns #{columns}"
    		if columns
    		     news_classifieds = distinct_weibo_classifieds();
			news_classifieds.each do |classified|
				if(classified.classified==name)
					respond_to do |format|
					format.html {
						flash[:error] = "Name #{name} already exists"
						redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/weibo'})
					}
					end
	      			return
	      		end
			end
			news_templates= distinct_weibo_templates();
			columns.each do |column|
				news_templates.each do |template|
					if(column==template.column_name)
						 newone = WeiboClassified.create! :classified => name,
                                 :template => template
     						newone.save!

					end

				end
    			end
			
    			respond_to do |format|
			format.html {
				flash[:notice] = l(:notice_successful_update)
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/weibo'})
			}
	      	end
    		else
    			respond_to do |format|
			format.html {
				flash[:notice] = "No Column selected"
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/weibo'})
			}
	      	end
    		end

    	
	end

	def new_forum
		name = params[:classified_name][:classified_name].strip()
    		columns = params[:columns]
    		Rails.logger.info "name: #{name}, columns #{columns}"
    		if columns
    		     news_classifieds = distinct_forum_classifieds();
			news_classifieds.each do |classified|
				if(classified.classified==name)
					respond_to do |format|
					format.html {
						flash[:error] = "Name #{name} already exists"
						redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/forum'})
					}
					end
	      			return
	      		end
			end
			news_templates= distinct_forum_templates();
			columns.each do |column|
				news_templates.each do |template|
					if(column==template.column_name)
						 newone = ForumClassified.create! :classified => name,
                                 :template => template
     						newone.save!

					end

				end
    			end
			
    			respond_to do |format|
			format.html {
				flash[:notice] = l(:notice_successful_update)
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/forum'})
			}
	      	end
    		else
    			respond_to do |format|
			format.html {
				flash[:notice] = "No Column selected"
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/forum'})
			}
	      	end
    		end

    	
	end


	def new_blog
		name = params[:classified_name][:classified_name].strip()
    		columns = params[:columns]
    		Rails.logger.info "name: #{name}, columns #{columns}"
    		if columns
    		     news_classifieds = distinct_blog_classifieds();
			news_classifieds.each do |classified|
				if(classified.classified==name)
					respond_to do |format|
					format.html {
						flash[:error] = "Name #{name} already exists"
						redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/blog'})
					}
					end
	      			return
	      		end
			end
			news_templates= distinct_blog_templates();
			columns.each do |column|
				news_templates.each do |template|
					if(column==template.column_name)
						 newone = BlogClassified.create! :classified => name,
                                 :template => template
     						newone.save!

					end

				end
    			end
			
    			respond_to do |format|
			format.html {
				flash[:notice] = l(:notice_successful_update)
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/blog'})
			}
	      	end
    		else
    			respond_to do |format|
			format.html {
				flash[:notice] = "No Column selected"
				redirect_to({:controller => 'templates', :action => 'index', :partial => 'templates/blog'})
			}
	      	end
    		end

    	
	end
end
