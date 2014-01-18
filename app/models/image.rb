class Image < ActiveRecord::Base
	include Redmine::SafeAttributes

	safe_attributes 'url', 'file_path', 'description', 'image_date'

end
