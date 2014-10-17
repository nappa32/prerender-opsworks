# settings
minimum = 1
current = `pstree -c |grep 'nodejs-+-phantomjs-+-{phantomjs}'|wc -l`.to_i

if minimum > current
  # kill existing processes
  `killall -9 nodejs phantomjs node`

  # start processes
  `nohup bash /root/prerender/start.sh &`
end
