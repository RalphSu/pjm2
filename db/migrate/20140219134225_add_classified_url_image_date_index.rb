class AddClassifiedUrlImageDateIndex < ActiveRecord::Migration
  def self.up
	tables = [:weibos, :news_releases, :weixins, :blogs, :forums, :summaries]

	# add indexes
	tables.each do |t|
		add_index t, [:classified, :image_date, :url]
	end
  end

  def self.down
  end
end
