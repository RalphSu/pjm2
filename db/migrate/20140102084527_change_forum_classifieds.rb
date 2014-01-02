#encoding: utf-8
class ChangeForumClassifieds < ActiveRecord::Migration
  def self.up
	 forum_title= Template.find(:first,
	        :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","标题"])

	 forum_hyperlink= Template.find(:first,
	        :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","链接"])

	 forum_click_num= Template.find(:first,
	        :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","点击数"])

	 forum_reply_num= Template.find(:first,
        :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","回复数"])

  	# change forum to TIE_BA
  	change_from_forum_to_tieba(forum_title)
  	change_from_forum_to_tieba(forum_hyperlink)
  	change_from_forum_to_tieba(forum_click_num)
  	change_from_forum_to_tieba(forum_reply_num)


  	# add date for TIE_BA
	forum_date= Template.find(:first,
        :conditions => ["#{Template.table_name}.template_type = ? AND #{Template.table_name}.column_name = ?", "论坛类模板","日期"])

    forum_forum = ForumClassified.create! :classified => "百度贴吧", :template => forum_date
    forum_forum.save!
  end

  def self.change_from_forum_to_tieba(template)
  	templates = ForumClassified.find(:all, :conditions=>[ "classified = ? AND template_id = #{template.id}", "论坛"], :order=> "id")
  	if templates.length == 2
  		t = templates.last
  		t.classified = "百度贴吧"
  		t.save!
  	end
  end

  def self.down
  end
end
