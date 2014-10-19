git "/root/prerender" do
  repository "https://github.com/prerender/prerender.git"
  revision "master"
  action :sync
end

node['prerender'].each do |k,v|
  bash "setup custom env settings : #{k}" do
    code <<-EOF
      export '#{k}'='#{v}' >> /root/prerender/env.sh
    EOF
    not_if "grep '#{k}'='#{v}' /root/prerender/env.sh"
  end
end

bash "npm install" do
  cwd "/root/prerender"
  code <<-EOF
    npm install
  EOF
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
