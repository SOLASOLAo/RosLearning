#!/bin/bash
# 启动珞石 SR5 仿真演示（fake hardware，不连真机）
set -e
ROKAE_WS="${1:-/media/administrator/D/Projects/Rokae}"
source /opt/ros/humble/setup.bash
source "$ROKAE_WS/install/setup.bash"
# 检查 memlock 权限（limits.conf 未生效时需要 sudo 方式）
if [ "$(ulimit -Sl)" != "unlimited" ]; then
  echo "[警告] memlock 未解锁，ros2_control 可能崩溃。"
  echo "重新登录生效 limits.conf，或用: sudo bash -c 'ulimit -l unlimited; $0 $1'"
fi
ros2 launch rokae_hardware rokae_moveit_launch.py robot_type:=SR5 use_fake_hardware:=true
