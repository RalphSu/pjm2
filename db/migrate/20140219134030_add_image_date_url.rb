class AddImageDateUrl < ActiveRecord::Migration
  def self.up
	# add image_date
	tables = [:weibos, :news_releases, :weixins, :blogs, :forums, :summaries]

	tables.each do |t|
		add_column t, :image_date, :date
	end

	# add url
	tables.each do |t|
		add_column t, :url, :string
	end

  end

  def self.down
  	tables = [:weibos, :news_releases, :weixins, :blogs, :forums, :summaries]
  	tables.each do |t|
		remove_column t, :image_date
	end
	tables.each do |t|
		remove_column t, :url
	end
  end
end
