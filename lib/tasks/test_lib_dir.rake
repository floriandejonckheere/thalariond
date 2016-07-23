require 'rake/testtask'

namespace :test do
  desc "Test libraries"
  Rake::TestTask.new(:lib) do |t|
    t.libs << "test"
    t.pattern = 'test/lib/**/*_test.rb'
    t.verbose = true
  end
end
