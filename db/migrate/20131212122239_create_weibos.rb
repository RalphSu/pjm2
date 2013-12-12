class CreateWeibos < ActiveRecord::Migration
  def self.up
    create_table :weibos do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :weibos
  end
end
