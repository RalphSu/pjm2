#encoding: utf-8
class AddTemplateColumns < ActiveRecord::Migration
  def self.up

  	blog_host = Template.create! :template_type => "新闻类模板",
                                 :column_name => "排名"
        blog_host.save!

  	blog_host = Template.create! :template_type => "微博类模板",
                                 :column_name => "点赞"
        blog_host.save!

        add_column :images, :image_date, :timestamp

  end

  def self.down
  	remove_column :images, :image_date
  end
end
