class NewsClassified < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :template

  safe_attributes 'classified'

end
