#-- encoding: UTF-8

module ReportTemplateHelper

	def get_templates(project)
		tree_data = []

		category = '新闻类模板'
		sub_classifieds = []
		NewsClassified.all(:select => "DISTINCT(classified)").each do |n|
			item = {}
			item[:title] = n.classified
			value ={}
			value[:category] = "#{category}"
			value[:classified] = "#{n.classified}"
			item[:value] = value
			sub_classifieds << item
		end
		tree = {
			:title => category,
			:children => sub_classifieds
		}
		tree_data << tree

		category = '微博类模板'
		sub_classifieds = []
		WeiboClassified.all(:select=> "DISTINCT(classified)").each do |n|
			item = {}
			item[:title] = n.classified
			value ={}
			value[:category] = "#{category}"
			value[:classified] = "#{n.classified}"
			item[:value] = value
			sub_classifieds << item
		end
		tree = {
			:title => category,
			:children => sub_classifieds
		}
		tree_data << tree

		category = '博客类模板'
		sub_classifieds = []
		BlogClassified.all(:select=> "DISTINCT(classified)").each do |n|
			item = {}
			item[:title] = n.classified
			value ={}
			value[:category] = "#{category}"
			value[:classified] = "#{n.classified}"
			item[:value] = value
			sub_classifieds << item
		end
		tree = {
			:title => category,
			:children => sub_classifieds
		}
		tree_data << tree

		category = '论坛类模板'
		sub_classifieds = []
		ForumClassified.all(:select=> "DISTINCT(classified)").each do |n|
			item = {}
			item[:title] = n.classified
			value ={}
			value[:category] = "#{category}"
			value[:classified] = "#{n.classified}"
			item[:value] = value
			sub_classifieds << item
		end
		tree = {
			:title => category,
			:children => sub_classifieds
		}
		tree_data << tree

		# fill the selected flag
		ReportTemplate.find(:all, :conditions=> {:project_id => project.id}).each do |t|
			tree_data.each do |td|
				if td[:title] == t.template_type
					td[:children].each do |item|
						if item[:title] == t.classified
							item[:select] = true
						end
					end
				end
			end
		end

		return tree_data
	end
end
