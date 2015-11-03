namespace :db do

  desc "Create admin account"
  task :create_admin => :environment do
    admin = User.create!(:uid => 'admin',
                  :email => 'admin@example.com',
                  :first_name => 'Administrator',
                  :password => 'abcd1234',
                  :confirmed_at => DateTime.now)

    admin.roles << Role.find_by(name: 'administrator')
  end

end
