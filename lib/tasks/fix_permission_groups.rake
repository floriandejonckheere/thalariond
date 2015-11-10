namespace :db do

  desc 'Fix missing and uncoupled permission groups'
  task :fix_permission_groups => :environment do
    Email.all.select { |e| e.group.nil? }.each do |email|
      p email.group
      group = Group.find_by(:name => email.to_s)
      if group
        group.email = email
        group.save!
      else
        email.create_permission_group
        email.save!
      end
      p email.group
    end
  end

end
