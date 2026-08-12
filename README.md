# ROS 2 Humble + MoveIt 2 学习笔记（含珞石 SR5 部署）

> ## 📖 日常使用请先看：[日常操作指导.md](日常操作指导.md)
> 包含：环境加载、各场景启动命令、真机安全守则、防卡死规矩、故障排查。

在 Ubuntu 22.04 + ROS 2 Humble 上，从零开始学习 ROS 2、部署 MoveIt 2，
并完成珞石（Rokae）xMate SR5-5 机械臂的 ROS 2 软件栈部署的完整记录。

## 环境

| 项目 | 版本/说明 |
|------|-----------|
| 系统 | Ubuntu 22.04.5 LTS |
| ROS 2 | Humble（二进制安装，/opt/ros/humble） |
| MoveIt 2 | 2.5.9（apt 二进制，**未**源码编译） |
| 机器人 | 珞石 xMate SR5-5/0.9c（6 轴） |
| 珞石软件栈 | rokae_ros2 v0.0.4 + xCore SDK 0.7.1 |

> 所有自建工程均放在 D 盘（NTFS 挂载）：`/media/administrator/D/Projects/`，
> 避免占用系统盘空间。

## 目录结构

```
RosLearning/
├── README.md                 # 本文件：总览与学习路线
├── 日常操作指导.md            # ⭐ 日常使用手册（手动操作步骤全在这）
├── notes/                    # 中文学习笔记
│   ├── 01-ROS2基础.md         # 节点/话题/talker-listener
│   ├── 02-MoveIt部署与演示.md  # MoveIt 安装、Panda 演示、RViz 操作
│   ├── 03-珞石SR5部署记录.md   # rokae_ros2 下载、编译、fake/真机启动
│   └── 04-踩坑记录.md          # memlock 权限、进程污染、RViz 卡顿、编译卡死
├── scripts/                  # 可复现的部署脚本
│   ├── setup_moveit.sh       # 安装 MoveIt 2 + Panda 演示包
│   ├── setup_rokae.sh        # 下载并编译珞石 rokae_ros2（含 SDK）
│   ├── setup_tutorials.sh    # 下载并编译 moveit2_tutorials (humble)
│   └── launch_sr5_fake.sh    # 启动 SR5 仿真演示
└── config/
    └── limits-realtime.conf  # ros2_control 实时权限配置（limits.conf）
```

## 学习路线

1. **ROS 2 基础**：节点、话题、`ros2 topic/node` 命令 → talker/listener
2. **MoveIt 2 入门**：RViz 中拖拽规划（Plan & Execute）
3. **MoveIt 官方教程**（humble 分支）：move_group_interface → planning_scene → Task Constructor
4. **珞石 SR5**：fake hardware 验证软件链 → 真机连接
5. **进阶**：servo 实时控制、感知管线、Gazebo 仿真

## 关键命令速查

```bash
source /opt/ros/humble/setup.bash

# Panda MoveIt 演示
ros2 launch moveit_resources_panda_moveit_config demo.launch.py

# 珞石 SR5 仿真
source /media/administrator/D/Projects/Rokae/install/setup.bash
ros2 launch rokae_hardware rokae_moveit_launch.py robot_type:=SR5 use_fake_hardware:=true

# MoveIt 官方教程第 2 课（第一个 C++ 程序）
source /media/administrator/D/Projects/MoveItTutorials/install/setup.bash
ros2 launch moveit2_tutorials move_group_interface_tutorial.launch.py
```

## 参考链接

- MoveIt 2 教程（Humble 版）: https://moveit.picknik.ai/humble/doc/tutorials/tutorials.html
- ROS 2 Humble 官方教程: https://docs.ros.org/en/humble/Tutorials.html
- 珞石 rokae_ros2: https://github.com/RokaeRobot/rokae_ros2
- 珞石 ROS2 在线文档: https://docs.rokae.com/docs/ROS2
