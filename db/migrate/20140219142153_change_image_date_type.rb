class ChangeImageDateType < ActiveRecord::Migration
  def self.up
	tables = [:weibos, :news_releases, :weixins, :blogs, :forums, :summaries]

	tables.each do |t|
		change_column t, :image_date, :string
	end
  end

  def self.down
  end
end
