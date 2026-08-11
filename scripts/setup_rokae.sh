#!/bin/bash
# 下载并编译珞石 rokae_ros2（含 xCore SDK）
# 用法: ./setup_rokae.sh [目标目录]
set -e
DEST="${1:-/media/administrator/D/Projects/Rokae}"
PROXY="${GH_PROXY:-https://gh-proxy.com/}"   # 代理不通时: export GH_PROXY=""
mkdir -p "$DEST" && cd "$DEST"

echo "==> 下载 rokae_ros2 源码"
[ -d rokae_ros2 ] || {
  curl -sL --retry 3 -o rokae_ros2.tar.gz \
    "${PROXY}https://codeload.github.com/RokaeRobot/rokae_ros2/tar.gz/refs/heads/main"
  gzip -t rokae_ros2.tar.gz
  tar xzf rokae_ros2.tar.gz && mv rokae_ros2-main rokae_ros2
}

echo "==> 下载 xCore SDK"
SDK_VER=$(cat rokae_ros2/rokae_hardware/sdk/VERSION)
if [ ! -f rokae_ros2/rokae_hardware/sdk/lib/libxCoreSDK.a ]; then
  curl -sL --retry 3 -o sdk.tar.gz \
    "${PROXY}https://github.com/RokaeRobot/xCoreSDK-CPP/releases/download/v${SDK_VER}/xCoreSDK-${SDK_VER}-linux-x86_64.tar.gz"
  gzip -t sdk.tar.gz
  mkdir -p sdk_tmp && tar xzf sdk.tar.gz -C sdk_tmp
  cp sdk_tmp/lib/Linux/x86_64/* rokae_ros2/rokae_hardware/sdk/lib/
  cd rokae_ros2/rokae_hardware/sdk/lib/ && ln -sf libxCoreSDK.so.${SDK_VER} libxCoreSDK.so
  cd "$DEST"
fi

echo "==> 安装依赖"
sudo apt-get install -y python3-rosdep python3-colcon-common-extensions
[ -f /etc/ros/rosdep/sources.list.d/20-default.list ] || sudo rosdep init
rosdep update
sudo -E bash -c "source /opt/ros/humble/setup.bash && rosdep install --from-paths $DEST/rokae_ros2 --ignore-src -r -y"

echo "==> 编译"
source /opt/ros/humble/setup.bash
MAKEFLAGS="-j4" colcon build --symlink-install --executor sequential
echo "== 完成! 启动前 source $DEST/install/setup.bash"
