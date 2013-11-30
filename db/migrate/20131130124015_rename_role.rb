#encoding: utf-8
class RenameRole < ActiveRecord::Migration
  def self.up
  	manaRole = Role.find_by_id(Role::SYSTEM_PROJECT_MANAGER)
  	# FIXME: use localization??
  	manaRole.name="项目管理员"
  	manaRole.save
  	devRole = Role.find_by_id(Role::SYSTEM_PROJECT_REVIEWER)
  	devRole.name="项目审核员"
  	devRole.save
  end

  def self.down

  end
end
