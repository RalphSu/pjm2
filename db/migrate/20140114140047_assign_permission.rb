#encoding: utf-8
class AssignPermission < ActiveRecord::Migration
  def self.up
          manaRole= Role.find(:first,
                            :conditions => ["#{Role.table_name}.name = ? ", '项目管理员'])

          # devRole= Role.find(:first,
          #                   :conditions => ["#{Role.table_name}.name = ? ", '项目管理员'])
	      if manaRole.nil?
	          manaRole= Role.find(:first,
	                            :conditions => ["#{Role.table_name}.name = ? ", '管理人员'])
	      end
	      if manaRole.nil?
	      	manaRole= Role.find(:first,
                            :conditions => ["#{Role.table_name}.name = ? ", "Manager"])
	      end
	      puts "manaRole is #{manaRole}"
          if manaRole
          	manaRole.add_permission!(:manager_permission)
          	manaRole.add_permission!(:view_news)
          	manaRole.save!()
          end

	reportRole= Role.find(:first,
          	      :conditions => ["#{Role.table_name}.name = ? ", '项目审核员'])
	if reportRole.nil?
        reportRole= Role.find(:first,
                      :conditions => ["#{Role.table_name}.name = ? ", '报告人员'])
	end
	if reportRole.nil?
	    reportRole= Role.find(:first,
                         :conditions => ["#{Role.table_name}.name = ? ", "Reporter"])
	end
	if reportRole
		reportRole.add_permission!(:reviwer_permission)
		reportRole.add_permission!(:view_news)
		reportRole.save!()
	end

  end

  def self.down
  end
end
