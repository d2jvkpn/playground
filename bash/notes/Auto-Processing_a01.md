### Linux Auto-Processing a01
---
Linux中10个一线工作中常用 Shell 脚本 
https://mp.weixin.qq.com/s?__biz=MzU3NTgyODQ1Nw==&mid=2247544217&idx=2&sn=65368a1323ca6ec0f3341034c730e507

#### 1. System Monitoring
```bash
####
threshold=1.0

load=$(uptime | awk -F ",  " '{print $3}' | awk -F ", " '{print $2}')

if (( $(echo "$load > $threshold" | bc -l) )); then
    # echo "system is overload: $load" | mail -s "system load alerts" admin@example.com
    notify-send -u critical "system is overload: $load"
fi

####
threshold=90
df_output=$(df -h)

while read -r line; do
    usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    if (( usage > threshold )); then
        echo "磁盘空间不足: $line" | mail -s "磁盘空间警报" admin@example.com
    fi
done <<< "$df_output"

####
service_name="nginx"
if ! systemctl is-active --quiet "$service_name"; then
    echo "服务 $service_name 未运行" | mail -s "服务状态警报" admin@example.com
fi
```

#### 2. Auto-Processing
```bash
####
log_dir="/path/to/logs"
days_to_keep=7

find "$log_dir" -type f -name "*.log" -mtime +$days_to_keep -delete

####
servers=("server1" "server2" "server3")
source_dir="/path/to/source"
destination_dir="/path/to/destination"

for server in "${servers[@]}"; do
    rsync -avz "$source_dir" "$server:$destination_dir"
done
```

#### 3. Monitoring network connectivity
```bash
service_ip="192.168.0.1"

if ! ping -c 1 -W 1 "$service_ip" > /dev/null; then
    echo "无法访问服务: $service_ip" | mail -s "网络连通性警报" admin@example.com
fi
```
