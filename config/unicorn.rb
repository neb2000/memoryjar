rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = '/srv/websites/memoryjar/current'
ENV['BUNDLE_GEMFILE'] = '/srv/websites/memoryjar/current/Gemfile'

worker_processes  1 
working_directory rails_root

listen '/tmp/unicorn.memoryjar.sock'
preload_app false 
timeout 30

pid rails_root + '/tmp/pids/unicorn.pid'
stderr_path rails_root + '/log/unicorn.err'
stdout_path rails_root + '/log/unicorn.log'

# Seamless deployment
before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = rails_root + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Old master already dead"
      # someone else did our job for us
    end
  end
end

# Establish DB connection
after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end