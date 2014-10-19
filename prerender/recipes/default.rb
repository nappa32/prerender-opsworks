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

bash "disable_all_plugins_and_server_start" do
  cwd "/root/prerender"
  code <<-EOH
    cp -a server.js server.js.bak
    cat server.js.bak |egrep -v -E "server.start|server.use" >  server.js
  EOH
end

%w(whitelist removeScriptTags s3HtmlCache).each do |plugin|
  bash "enable_plugin: #{plugin}" do
    cwd "/root/prerender"
    code <<-EOH
      echo "server.use(prerender.#{plugin}());" >> server.js
    EOH
  end
end

bash "enable_server.start" do
  cwd "/root/prerender"
  code <<-EOH
    echo "server.start();" >> server.js
  EOH
end


cron "cronjob_to_monitor_process" do
  minute '*/1'
  user "root"
  home "/root/prerender"
  command "/usr/local/bin/ruby /root/prerender/cron.rb"
end
