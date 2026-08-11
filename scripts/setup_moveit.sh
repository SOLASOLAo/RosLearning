#!/bin/bash
# 安装 MoveIt 2 + Panda 演示包（Ubuntu 22.04 + ROS 2 Humble）
set -e
source /opt/ros/humble/setup.bash
sudo apt-get update
sudo apt-get install -y ros-humble-moveit \
  ros-humble-moveit-resources-panda-moveit-config \
  ros-humble-ros2-control ros-humble-ros2-controllers ros-humble-xacro
echo "== 安装完成，验证："
ros2 pkg list | grep -c moveit
echo "启动演示: ros2 launch moveit_resources_panda_moveit_config demo.launch.py"
