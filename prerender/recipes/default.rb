git "/root/prerender" do
  repository "https://github.com/prerender/prerender.git"
  revision "master"
  action :sync
end

bash "npm_install_it" do
  cwd "/root/prerender"
  command "cd /root/prerender && npm install"
end

["cron.rb", "start.sh"].each do |filename|
  template "/root/prerender/#{filename}" do
    mode '0755'
    source filename
  end
end

cron "cronjob_to_monitor_process" do
  minute '*/1'
  user "root"
  home "/root/prerender"
  command "/usr/local/bin/ruby /root/prerender/cron.rb"
end
