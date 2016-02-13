# http://stackoverflow.com/questions/5545000/how-to-launch-a-thread-at-the-start-of-a-rails-app-and-terminate-it-at-stop
at_exit do
   finalizer_files = File.join(::Rails.root.to_s, 'config/finalizers/*.rb')
   Dir.glob(finalizer_files).sort.each do |finalizer_file|
      require finalizer_file
   end
end
