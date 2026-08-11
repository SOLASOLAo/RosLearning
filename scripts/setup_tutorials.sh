#!/bin/bash
# 下载并编译 MoveIt 官方教程 (humble 分支)
# 用法: ./setup_tutorials.sh [目标目录]
set -e
DEST="${1:-/media/administrator/D/Projects/MoveItTutorials}"
PROXY="${GH_PROXY:-https://gh-proxy.com/}"
mkdir -p "$DEST/src" && cd "$DEST/src"

echo "==> 下载 moveit2_tutorials (humble)"
[ -d moveit2_tutorials ] || {
  curl -sL --retry 3 -o tutorials.tar.gz \
    "${PROXY}https://codeload.github.com/moveit/moveit2_tutorials/tar.gz/refs/heads/humble"
  gzip -t tutorials.tar.gz
  tar xzf tutorials.tar.gz && mv moveit2_tutorials-humble moveit2_tutorials
}

echo "==> 安装依赖"
sudo -E bash -c "source /opt/ros/humble/setup.bash && rosdep install --from-paths $DEST/src/moveit2_tutorials --ignore-src -r -y"

echo "==> 编译（限制并行防止卡死）"
source /opt/ros/humble/setup.bash
cd "$DEST"
MAKEFLAGS="-j4" colcon build --symlink-install --executor sequential
echo "== 完成! 第2课示例:"
echo "   source $DEST/install/setup.bash"
echo "   ros2 launch moveit2_tutorials move_group_interface_tutorial.launch.py"
