class Template < ActiveRecord::Base
  include Redmine::SafeAttributes
  safe_attributes 'template_type',
    'column_name'
end
