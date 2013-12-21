class NewsClassified < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :template

  safe_attributes 'classified'

  has_many :news_release_field

end
