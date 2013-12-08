#encoding: utf-8
class RenameRole < ActiveRecord::Migration
  def self.up
    manaRole= Role.find(:first,
                            :conditions => ["#{Role.table_name}.name = ? ", "Manager"])
      if manaRole.nil?
          manaRole= Role.find(:first,
                            :conditions => ["#{Role.table_name}.name = ? ", "管理人员"])
      end
    if manageRole
  	 manaRole.name="项目管理员"
  	 manaRole.save
    end

    devRole= Role.find(:first,
                           :conditions => ["#{Role.table_name}.name = ? ", "Reporter"])
    if devRole.nil?
        devRole= Role.find(:first,
                          :conditions => ["#{Role.table_name}.name = ? ", "报告人员"])
    end
    if devRole
  	 devRole.name="项目审核员"
  	 devRole.save
    end
  end

  def self.down

  end
end
