# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 60
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # Sidekiq
  @sidekiq_pid ||= spawn("bundle exec sidekiq -q default")
  t = Thread.new {
    Process.wait(@sidekiq_pid)
    puts "Worker died. Bouncing unicorn."
    Process.kill 'QUIT', Process.pid
  }
  t.abort_on_exception = true

  # Clockwork
  @clockwork_pid ||= spawn("bundle exec clockwork config/clockwork.rb")
  t = Thread.new {
    Process.wait(@clockwork_pid)
    puts "Worker died. Bouncing unicorn."
    Process.kill 'QUIT', Process.pid
  }
  t.abort_on_exception = true
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
end
