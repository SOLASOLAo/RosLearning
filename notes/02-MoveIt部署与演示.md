# 02 - MoveIt 2 部署与演示

## 安装（apt 二进制，勿源码编译）

```bash
sudo apt install -y ros-humble-moveit                        # MoveIt 2 元包
sudo apt install -y ros-humble-moveit-resources-panda-moveit-config  # Panda 演示
sudo apt install -y ros-humble-ros2-control ros-humble-ros2-controllers ros-humble-xacro
```

> 注意：官方 getting started 教程让卸载二进制 MoveIt 再源码编译，
> 普通学习**不需要**，源码编译耗时且容易破坏环境。

## Panda 演示

```bash
source /opt/ros/humble/setup.bash
ros2 launch moveit_resources_panda_moveit_config demo.launch.py
```

启动内容：RViz + move_group（OMPL 规划器）+ ros2_control_node + 3 个控制器。

## RViz 中操作机械臂

1. 拖动末端执行器的彩色交互标记到目标位姿
2. 左侧 MotionPlanning 面板 → Planning 标签
3. **Plan**（规划，显示绿色轨迹）→ **Execute**（执行）
4. Goal State 选 `random valid` 可随机生成目标姿态

## 已知问题

1. **ros2_control 需要 memlock 权限**，否则崩溃（std::bad_alloc / Resource temporarily unavailable）
   解决：`/etc/security/limits.conf` 加入实时权限后重新登录（见 config/limits-realtime.conf）
2. **warehouse-ros-mongo 装不上**：Humble 已改用 sqlite 版，属正常现象，不影响使用
3. **RViz "Save Config As" 卡顿**：RViz 渲染循环占满单核 + GTK 文件对话框枚举慢。
   对策：用 Ctrl+S 直接保存；或在文件名框直接输入完整路径
