#!/bin/bash

# 指定配置文件路径
config_file=".env.local"

# 从配置文件中读取信息
port=13001

# 检查port是否已读取
if [ -z "$port" ]; then
  echo "Port not found in configuration file."
  exit 1
fi

echo "Looking for processes using TCP port $port..."

# 使用ss命令获取特定TCP端口的进程信息
process_info=$(ss -tlnp | grep :$port)

# 检查是否找到了进程
if [ ! -z "$process_info" ]; then
    # 提取PID
    pid=$(echo "$process_info" | sed -n 's/.*pid=\([0-9]*\).*/\1/p')
    # 提取进程名
    process_name=$(echo "$process_info" | sed -n 's/.*"(\([^"]*\).*/\1/p')
    
    echo "在端口 $port 上找到进程"
    echo "进程名: $process_name"
    echo "PID: $pid"
    
    # 如果需要杀死该进程，取消下面两行的注释
    echo "正在终止进程..."
    kill -9 $pid
else
    echo "在端口 $port 上没有找到进程。"
fi

sleep 2

HOST="0.0.0.0" PORT="$port" nohup npm run dev > nohub.log 2>&1 &

echo "start success!!"
