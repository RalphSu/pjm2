#encoding: utf-8

class InsertWeixinTemplate < ActiveRecord::Migration
  def self.up
  	weixin_platform = Template.create! :template_type => "微信类模板",
  		:column_name => "平台"
        weixin_platform.save!

        weixin_content = Template.create! :template_type => "微信类模板",
  		:column_name => "内容"
        weixin_content.save!

        weixin_link = Template.create! :template_type => "微信类模板",
  		:column_name => "链接"
        weixin_link.save!

	weixin_tweets = Template.create! :template_type => "微信类模板",
  		:column_name => "转发数"
        weixin_tweets.save!

        weixin_comments = Template.create! :template_type => "微信类模板",
  		:column_name => "评论数"
        weixin_comments.save!

        weixin_fans = Template.create! :template_type => "微信类模板",
  		:column_name => "粉丝数"
        weixin_fans.save!

        weixin_nice = Template.create! :template_type => "微信类模板",
  		:column_name => "点赞"
        weixin_nice.save!

        weixin_hot = Template.create! :template_type => "微信类模板",
  		:column_name => "热门微视"
        weixin_hot.save!

        weixin_tag = Template.create! :template_type => "微信类模板",
  		:column_name => "热门标签"
        weixin_tag.save!

        weixin_date = Template.create! :template_type => "微信类模板",
  		:column_name => "日期"
        weixin_date.save!

        weixin_screenshot = Template.create! :template_type => "微信类模板",
  		:column_name => "截图"
        weixin_screenshot.save!

  end

  def self.down
  end
end
