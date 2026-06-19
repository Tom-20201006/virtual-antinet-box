# Architecture

## 总体结构

项目使用 Godot 4 + GDScript。主场景为 `res://scenes/Main.tscn`，实际 Demo 由 `scripts/Main.gd` 在运行时搭建。这样可以保持场景文件清晰，同时让几何体、碰撞体和交互逻辑在代码中明确分层。

## 核心节点

- `Main`：创建环境、UI、卡片盒、默认卡片、控制器和状态系统。
- `CardBox`：创建卡片盒外壳和 3 个抽屉。
- `Drawer`：创建抽屉几何体、碰撞体、内容根节点和开合逻辑。
- `Card`：创建薄长方体卡片，包含正面、背面、边缘和碰撞体。
- `Divider`：继承卡片行为，但使用更高的薄片尺寸和纯色材质。
- `CameraController`：处理右键旋转、中键平移、滚轮缩放和预设视角。
- `InteractionController`：处理鼠标选中、拖拽、抽屉开合、键盘旋转/翻面/保存/加载。
- `CardImporter`：打开本地文件选择器，把图片复制到 `user://imported_cards` 并生成新卡片。
- `WorldState`：保存和加载 JSON 状态。
- `PhysicsSleepManager`：记录交互对象的 active/sleeping 状态，为后续大量卡片优化预留入口。

## 外观与交互分离

卡片和抽屉都采用：

- `VisualRoot`：几何体和材质。
- `CollisionRoot`：碰撞体。
- 根节点脚本：交互逻辑和状态。

后续如果替换为精细模型，只需要替换 `VisualRoot` 下的内容，交互和保存逻辑不需要重写。

## 状态边界

保存数据只包含：

- 卡片或分隔片 ID。
- 图片资源路径。
- 位置。
- 旋转。
- 所在区域。
- 抽屉开合程度。
- 尺寸和简单物理状态。

保存数据不包含 OCR 文本、标签、主题、链接、摘要、索引或任何语义内容。
