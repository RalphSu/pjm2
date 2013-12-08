#encoding: utf-8
class InsertForumTemplate < ActiveRecord::Migration
  def self.up
  	    forum_forum = Template.create! :template_type => "论坛类模板",
                                 :column_name => "论坛"
        forum_forum.save!
      
        forum_area= Template.create! :template_type => "论坛类模板",
                                 :column_name => "板块"
        forum_area.save!

        forum_if_recommend= Template.create! :template_type => "论坛类模板",
                                 :column_name => "是否推荐"
        forum_if_recommend.save!

        forum_title= Template.create! :template_type => "论坛类模板",
                                 :column_name => "标题"
        forum_title.save!

        forum_hyperlink= Template.create! :template_type => "论坛类模板",
                                 :column_name => "链接"
        forum_hyperlink.save!       

        forum_click_num= Template.create! :template_type => "论坛类模板",
                                 :column_name => "点击数"
        forum_click_num.save!   

   		forum_reply_num= Template.create! :template_type => "论坛类模板",
                                 :column_name => "回复数"
        forum_reply_num.save! 

        forum_date= Template.create! :template_type => "论坛类模板",
                                 :column_name => "日期"
        forum_date.save!

        forum_if_awesome= Template.create! :template_type => "论坛类模板",
                                 :column_name => "是否加精"
        forum_if_awesome.save!

        forum_if_top= Template.create! :template_type => "论坛类模板",
                                 :column_name => "是否置顶"
        forum_if_top.save!

  end

  def self.down
  end
end
