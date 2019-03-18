pm = dynamic
pm.max_children = $corecount * 3
pm.start_servers = $corecount
pm.min_spare_servers = $corecount / 2
pm.max_spare_servers = $corecount * 2
pm.max_requests = 500
