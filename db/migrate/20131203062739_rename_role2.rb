#encoding: utf-8
class RenameRole2 < ActiveRecord::Migration
def self.up
    manaRole= Role.find(:first,
                            :conditions => ["#{Role.table_name}.name = ? ", "Manager"])
      if manaRole.nil?
          manaRole= Role.find(:first,
                            :conditions => ["#{Role.table_name}.name = ? ", '管理人员'])
      end
    if manaRole
  	 manaRole.name="项目管理员"
  	 manaRole.save
    end

    reportRole= Role.find(:first,
                           :conditions => ["#{Role.table_name}.name = ? ", "Reporter"])
    if reportRole.nil?
        reportRole= Role.find(:first,
                          :conditions => ["#{Role.table_name}.name = ? ", '报告人员'])
    end
    if reportRole
  	 reportRole.name="项目审核员"
  	 reportRole.save
    end
  end

  def self.down

  end
end
