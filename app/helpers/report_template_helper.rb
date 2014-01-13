#-- encoding: UTF-8

module ReportTemplateHelper

	def get_templates(project)
		tree_data = []

		project_tree_map= {}
		
		# fill the selected flag
		ReportTemplate.find(:all, :conditions=> {:project_id => project.id}).each do |t|
			if not project_tree_map.has_key?(t.template_type)
			 	project_tree_map[t.template_type]=[]
			end
			project_tree_map[t.template_type]<<t.classified;
		end
		category = '新闻类模板'
		sub_classifieds = []
		NewsClassified.all(:select => "DISTINCT(classified)").each do |n|
			skip=false
			if project_tree_map.has_key?(category)
				project_tree_map[category].each do |f|
				 	if f==n.classified
				 		skip=true
				 	end

				end
			end	

			if not skip
				item = {}
				item[:title] = n.classified
				value ={}
				value[:category] = "#{category}"
				value[:classified] = "#{n.classified}"
				item[:value] = value
				sub_classifieds << item
			end
		end
		if sub_classifieds.length>0
			tree = {
				:title => category,
				:children => sub_classifieds
			}
			tree_data << tree
		end

		

		category = '微博类模板'
		sub_classifieds = []
		WeiboClassified.all(:select=> "DISTINCT(classified)").each do |n|
			skip=false
			if project_tree_map.has_key?(category)
				project_tree_map[category].each do |f|
				 	if f==n.classified
				 		skip=true
				 	end

				end
			end	

			if not skip
				item = {}
				item[:title] = n.classified
				value ={}
				value[:category] = "#{category}"
				value[:classified] = "#{n.classified}"
				item[:value] = value
				sub_classifieds << item
			end
		end
		if sub_classifieds.length>0
			tree = {
				:title => category,
				:children => sub_classifieds
			}
			tree_data << tree
		end
		

		category = '博客类模板'
		sub_classifieds = []
		BlogClassified.all(:select=> "DISTINCT(classified)").each do |n|
			skip=false
			if project_tree_map.has_key?(category)
				project_tree_map[category].each do |f|
				 	if f==n.classified
				 		skip=true
				 	end

				end
			end	

			if not skip
				item = {}
				item[:title] = n.classified
				value ={}
				value[:category] = "#{category}"
				value[:classified] = "#{n.classified}"
				item[:value] = value
				sub_classifieds << item
			end
		end
		if sub_classifieds.length>0
			tree = {
				:title => category,
				:children => sub_classifieds
			}
			tree_data << tree
		end

		category = '论坛类模板'
		sub_classifieds = []
		ForumClassified.all(:select=> "DISTINCT(classified)").each do |n|
			skip=false
			if project_tree_map.has_key?(category)
				project_tree_map[category].each do |f|
				 	if f==n.classified
						Rails.logger.info " project_tree_map category:#{category},classified:#{n.classified} f: #{f} !"
				 		skip=true
				 	end

				end
			end	

			if not skip
				item = {}
				item[:title] = n.classified
				value ={}
				value[:category] = "#{category}"
				value[:classified] = "#{n.classified}"
				item[:value] = value
				sub_classifieds << item
			end
		end
		if sub_classifieds.length>0
			tree = {
				:title => category,
				:children => sub_classifieds
			}
			tree_data << tree
		end



		return tree_data
	end


	def get_projecttemplates(project)
		tree_map= {}
		tree_data=[]
		# fill the selected flag
		ReportTemplate.find(:all, :conditions=> {:project_id => project.id}).each do |t|
			if not tree_map.has_key?(t.template_type)
			 	tree_map[t.template_type]=[]
			end
			item = {}
			item[:title] = t.classified
			value ={}
			value[:category] = t.template_type
			value[:classified] = t.classified
			item[:value] = value
			tree_map[t.template_type]<<item;
		end
		
		tree_map.each do |k,v|
		 	tree ={
		 		:title=>k,
		 		:children=>v
		 	}
		 	tree_data<<tree
		 end

		return tree_data
	end
end
