# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 60
preload_app true

# TODO: ADD back if using sidekiq
#before_fork do |server, worker|
  #Signal.trap 'TERM' do
    #puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    #Process.kill 'QUIT', Process.pid
  #end

  #@sidekiq_pid ||= spawn("bundle exec sidekiq -q paperclip -q default")
  #t = Thread.new {
    #Process.wait(@sidekiq_pid)
    #puts "Worker died. Bouncing unicorn."
    #Process.kill 'QUIT', Process.pid
  #}
  #t.abort_on_exception = true

  #defined?(ActiveRecord::Base) and
    #ActiveRecord::Base.connection.disconnect!
#end

#after_fork do |server, worker|
  #Signal.trap 'TERM' do
    #puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  #end

  #defined?(ActiveRecord::Base) and
    #ActiveRecord::Base.establish_connection
#end
