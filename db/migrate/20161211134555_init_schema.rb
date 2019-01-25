# frozen_string_literal: true

class InitSchema < ActiveRecord::Migration[5.2]
  def up
    create_table 'auth_events' do |t|
      t.text 'component', :null => false
      t.text 'action', :null => false
      t.boolean 'result', :null => false
      t.text 'ip'
      t.text 'agent'
      t.integer 'user_id'
      t.datetime 'timestamp', :null => false
      t.datetime 'created_at', :null => false
      t.datetime 'updated_at', :null => false
      t.index ['user_id'], :name => 'index_auth_events_on_user_id'
    end
    create_table 'groups' do |t|
      t.string 'name', :null => false
      t.string 'display_name'
      t.integer 'user_id'
      t.datetime 'created_at', :null => false
      t.datetime 'updated_at', :null => false
      t.index ['name'], :name => 'index_groups_on_name', :unique => true
    end
    create_table 'groups_services', :id => false do |t|
      t.integer 'group_id', :null => false
      t.integer 'service_id', :null => false
      t.index %w[group_id service_id], :name => 'index_groups_services_on_group_id_and_service_id', :unique => true
    end
    create_table 'groups_users', :id => false do |t|
      t.integer 'group_id', :null => false
      t.integer 'user_id', :null => false
      t.index %w[group_id user_id], :name => 'index_groups_users_on_group_id_and_user_id', :unique => true
    end
    create_table 'notifications' do |t|
      t.text 'title', :null => false
      t.text 'text', :null => false
      t.boolean 'read', :default => false, :null => false
      t.integer 'user_id'
      t.datetime 'timestamp', :null => false
      t.datetime 'created_at', :null => false
      t.datetime 'updated_at', :null => false
    end
    create_table 'roles' do |t|
      t.string 'name', :null => false
      t.string 'display_name'
      t.datetime 'created_at', :null => false
      t.datetime 'updated_at', :null => false
      t.integer 'order'
      t.index ['name'], :name => 'index_roles_on_name', :unique => true
    end
    create_table 'roles_services', :id => false do |t|
      t.integer 'service_id', :null => false
      t.integer 'role_id', :null => false
      t.index %w[service_id role_id], :name => 'index_roles_services_on_service_id_and_role_id', :unique => true
    end
    create_table 'roles_users', :id => false do |t|
      t.integer 'user_id', :null => false
      t.integer 'role_id', :null => false
      t.index %w[user_id role_id], :name => 'index_roles_users_on_user_id_and_role_id', :unique => true
    end
    create_table 'services' do |t|
      t.string 'uid', :null => false
      t.string 'display_name', :default => '', :null => false
      t.string 'encrypted_password', :default => '', :null => false
      t.integer 'sign_in_count', :default => 0, :null => false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.integer 'failed_attempts', :default => 0, :null => false
      t.string 'unlock_token'
      t.datetime 'locked_at'
      t.datetime 'created_at', :null => false
      t.datetime 'updated_at', :null => false
      t.boolean 'enabled', :default => true
      t.index ['uid'], :name => 'index_services_on_uid', :unique => true
      t.index ['unlock_token'], :name => 'index_services_on_unlock_token', :unique => true
    end
    create_table 'users' do |t|
      t.string 'uid', :null => false
      t.string 'first_name', :default => '', :null => false
      t.string 'last_name', :default => ''
      t.string 'email', :default => '', :null => false
      t.string 'encrypted_password', :default => '', :null => false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.integer 'sign_in_count', :default => 0, :null => false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.integer 'failed_attempts', :default => 0, :null => false
      t.string 'unlock_token'
      t.datetime 'locked_at'
      t.datetime 'created_at', :null => false
      t.datetime 'updated_at', :null => false
      t.string 'confirmation_token'
      t.datetime 'confirmed_at'
      t.datetime 'confirmation_sent_at'
      t.string 'unconfirmed_email'
      t.boolean 'enabled', :default => true
      t.boolean 'notifications_enabled', :default => true
      t.index ['confirmation_token'], :name => 'index_users_on_confirmation_token', :unique => true
      t.index ['email'], :name => 'index_users_on_email', :unique => true
      t.index ['reset_password_token'], :name => 'index_users_on_reset_password_token', :unique => true
      t.index ['uid'], :name => 'index_users_on_uid', :unique => true
      t.index ['unlock_token'], :name => 'index_users_on_unlock_token', :unique => true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'The initial migration is not revertable'
  end
end
