# 05 - MoveIt 快速入门（RViz 教程笔记）

> 原文（Humble 版）：
> https://moveit.picknik.ai/humble/doc/tutorials/quickstart_in_rviz/quickstart_in_rviz_tutorial.html
>
> 这篇教程教你用 RViz + MoveIt 插件完成：搭建规划场景、交互式设置起始/目标状态、
> 测试规划器、可视化轨迹。是所有后续教程的基础。

## 启动方式（我们的环境）

```bash
# 方式 A：教程自带 demo（推荐，与教程完全一致）
ws_tutorials
ros2 launch moveit2_tutorials demo.launch.py

# 方式 B：系统 Panda 演示包（轻量等价）
ros2 launch moveit_resources_panda_moveit_config demo.launch.py
```

> 教程原文用 `rviz_config:=panda_moveit_config_demo_empty.rviz` 启动一个空 RViz
> 让你手动添加插件，目的是**学会手动配置插件**。日常直接默认启动即可。

## Step 1：MotionPlanning 插件配置（了解即可）

RViz 左侧 Displays 面板里的 MotionPlanning 项，关键配置：

| 配置项 | 值 | 说明 |
|--------|-----|------|
| Fixed Frame（Global Options 里） | `/panda_link0` | 世界参考坐标系 |
| Robot Description | `robot_description` | 机器人模型话题 |
| Planning Scene Topic | `/monitored_planning_scene` | 规划场景话题 |
| Planned Path → Trajectory Topic | `/display_planned_path` | 规划轨迹显示话题 |
| Planning Request → Planning Group | `panda_arm` | 规划组（SR5 则是 `rokae_arm`） |

## Step 2：四个可视化图层（重点理解）

RViz 里其实叠了 **4 个机器人**，用复选框开关：

| 图层 | 颜色/含义 | 开关位置 | 默认 |
|------|-----------|----------|------|
| Scene Robot | 规划场景中的当前状态 | Scene Robot → Show Robot Visual | ✅ 开 |
| Planned Path | 规划出的路径 | Planned Path → Show Robot Visual | ✅ 开 |
| Start State | **绿色**手臂 = 规划起点 | Planning Request → Query Start State | ❌ 关 |
| Goal State | **橙色**手臂 = 规划终点 | Planning Request → Query Goal State | ✅ 开 |

## Step 3：与 Panda 交互（拖拽操作）

1. 打开 Query Start State 和 Query Goal State，画面出现绿、橙两个手臂
2. 每个手臂末端有**彩色交互标记**（圆环=旋转，箭头=平移）
3. 顶部工具栏选 **Interact** 工具（没有就点 "+" 添加），即可拖动手臂

### 3.1 碰撞实验（理解碰撞感知 IK）

- 只留绿色 Start State，把它拖到**自己撞自己**的姿势 → 碰撞的连杆变**红色**
- 关键开关：Planning 标签页的 **"Use Collision-Aware IK"**
  - ✅ 勾选：IK 求解器会自动找无碰撞的等效姿势（你很难拖出碰撞）
  - ❌ 不勾：允许碰撞姿势出现（便于观察红色高亮）

### 3.2 工作空间边界

把末端拖出可达范围，观察会发生什么——末端会被"拽回"可达边界，
这是 IK 求解失败/降级的表现。

### 3.3 Joints 标签页与 Null Space Exploration ⭐

MotionPlanning 面板底部有 **Joints** 标签页：
- 可以**逐个关节**拖动滑块
- 对 Panda 这种 7 轴冗余机械臂，会出现一个特殊滑块：
  **"null space exploration"（零空间探索）**
- 拖动它：**末端纹丝不动，只有肘部在动**——这就是零空间自运动的直观演示
  （原理见 04 笔记之后的讨论：7 关节 - 6 自由度 = 1 个冗余自由度）

> 💡 我们的 SR5 是 6 轴无冗余，这个滑块对它无效果；
> 但 Panda 演示里一定要拖一下，这是理解冗余自由度最直观的方式。

## Step 4：运动规划实战

### 4.1 基本规划流程

1. 拖动绿色 Start State 到起点位置
2. 拖动橙色 Goal State 到目标位置
3. 确认两者都不处于碰撞状态
4. 勾选 Planned Path 的 **Show Trail**（显示轨迹尾迹）
5. 点 **Plan** → 看到手臂运动动画和轨迹尾迹

### 4.2 逐点检查轨迹（Trajectory Slider）

- 菜单 Panels → **Trajectory - Trajectory Slider** → 出现滑块面板
- Plan 之后可以拖动滑块**逐帧查看**轨迹路点，或点 Play 播放
- ⚠️ 改了目标点必须先重新 Plan 再 Play，否则看到的是旧轨迹

### 4.3 笛卡尔路径（直线运动）

- 勾选 **"Use Cartesian Path"** 后再 Plan：
  末端会走**直线**（笛卡尔空间插值），而不是关节空间的弯曲路径
- 适合焊接、涂胶、直线搬运等工艺；成功率比自由规划低（可能中途遇奇异点）

### 4.4 执行与速度调节

- **Plan & Execute** = 规划完立即执行；**Execute** = 执行已规划好的轨迹
- 默认速度/加速度缩放为最大值的 **10%**（0.1）——安全第一
- 调节位置：Planning 标签页的 Velocity/Acceleration Scaling 滑块
- 想改默认值：修改 moveit_config 里的 `config/joint_limits.yaml`

## Step 5：为后续教程做准备

### 添加 RvizVisualToolsGui 面板（后面教程要用）

菜单 Panels → Add New Panels → 选 **RvizVisualToolsGui** → OK。
后续教程的演示程序会往这个面板发"下一步"按钮。

### 保存你的 RViz 配置

- **用 Ctrl+S**（File → Save Config），不要用 Save Config As（对话框很卡，
  原因见 04-踩坑记录）
- 我们的自定义配置：`~/.rviz/my_moveit.rviz`
- 用指定配置启动：`rviz2 -d ~/.rviz/my_moveit.rviz`

## 对应到 SR5 的操作差异

| Panda 教程 | SR5 对应 |
|------------|----------|
| Planning Group: `panda_arm` | `rokae_arm` |
| Fixed Frame: `/panda_link0` | `/world` 或 `/xMateSR5_base` |
| 7 轴，有 null space 滑块 | 6 轴，无冗余滑块 |
| `use_fake_hardware` 仿真 | `use_fake_hardware:=true` 仿真 |

## 本节小结（记住这些就够了）

1. RViz 里 4 个图层：场景机器人、规划路径、绿色起点、橙色终点
2. Interact 工具 + 末端标记 = 拖拽设置起点/终点
3. Use Collision-Aware IK 决定拖拽时是否自动避自碰撞
4. Plan → （检查轨迹）→ Execute；速度默认只有 10%
5. Use Cartesian Path = 末端走直线
6. 零空间探索滑块只在冗余机械臂（如 7 轴 Panda）上有意义

## 常见问题：点了 Plan 但看不到轨迹

**现象**：Planning 标签页点 Plan 后，终端/move_group 日志显示
`Motion plan was computed successfully`，但 RViz 里看不到任何轨迹。

**原因**：教程 Step 3 碰撞实验让你取消勾选
`Planned Path → Show Robot Visual`，Step 4 之前需要**重新勾选**，忘了就看不到轨迹。

**排查清单**（Displays 面板 → MotionPlanning）：
1. `Planned Path → Show Robot Visual` = ✅（最关键）
2. `Planned Path → Trajectory Topic` = `/display_planned_path`
3. `Planning Request → Query Goal State` = ✅
4. `Planning Request → Planning Group` = `panda_arm`
5. `Global Options → Fixed Frame` = `panda_link0`
6. 想看轨迹尾迹：勾选 `Planned Path → Show Trail`

**终极解决**：重启 demo 用默认完整配置（不带 rviz_config 参数）：
```bash
ws_tutorials
ros2 launch moveit2_tutorials demo.launch.py
```
