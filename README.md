# Personal Plan

Windows 桌面日 / 周 / 月计划便签，支持任务完成度、17:30 复盘提醒、DeepSeek AI 总结、开机自启动和迷你浮窗。

## 外观

- 无系统边框，可拖动标题移动窗口，右下角可调整大小。
- 默认背景透明度 80%，文字和控件独立保持清晰，避免大面积实色卡片。
- **深色环境**：适合深色桌面或下层窗口，使用亮文字、青色强调与暗阴影。
- **浅色环境**：适合浅色桌面或下层窗口，使用深蓝文字、深青强调与轻微亮阴影。
- 标题栏的“深环境 / 浅环境”按钮可以一键切换。这里的环境指软件下面的桌面或窗口，并非 Windows 主题。
- 设置可调整模式、透明度、背景颜色、正文文字颜色；两种模式分别保存配色。
- 点击“−”缩成迷你浮窗，显示今日完成度；双击浮窗展开，右键菜单可设置或退出。

## 使用

1. 运行 `PersonalPlan.exe`（本机版本位于 `D:\Personal Plan`）。
2. 在设置中填写自己的 DeepSeek API key，测试连接后保存。
3. 切换日、周、月计划，输入任务并勾选完成。复盘备注自动保存。
4. 周 / 月目标完成度和周期内每日任务完成度分开统计，避免重复计算。
5. 用日期和左右箭头查看历史或提前填写计划；可导出当前周期为文本。

## 提醒与 AI

- 工作日每天 17:30：日总结、明天的日计划。
- 每周五 17:30：周总结、下周计划。
- 每月最后一个工作日 17:30：月总结、下月计划。
- 工作日默认周一至周五，设置支持休息日期、调休上班日期。
- 当天提醒合并，支持 10 分钟后再次提醒；当天到点后启动会补发，关机和退出期间无法提醒，跨天不补发。
- 周 / 月提醒时可自动生成总结，也可手动生成。自动生成不覆盖已有总结。
- 生成总结会将对应周期任务、勾选状态与复盘备注发送给 DeepSeek，产生你自己的 API 费用。
- 默认模型 `deepseek-flash`；可在设置中更改。API 文档：[DeepSeek](https://api-docs.deepseek.com/quick_start)。

## 数据

数据保存在程序同目录的 `Data/`，本机为 `D:\Personal Plan\Data`。密钥通过 Windows DPAPI 加密，绑定当前 Windows 用户；计划与总结以 JSON 保存在本机。`planner.json.bak` 是上一次保存备份。迁移前备份位于本机 `Backups/`，历史旧版数据位于 `LegacyData/`（如存在）。

`Data/`、备份、密钥、EXE 和测试图片均被 Git 忽略。它们不应上传 GitHub。复制应用到其他电脑后需要重新填写 API key。

## 构建和自检

依赖 Windows .NET Framework 4.x / WPF，不需要 Python、Node 或 NuGet。

```powershell
powershell -ExecutionPolicy Bypass -File .\BuildPersonalPlan.ps1
.\PersonalPlan.exe --self-test
```

结果写入 `self-test.txt`。`GlassPlanner.cs` 是当前 WPF 界面，`PersonalPlan.cs` 包含共享数据、日期、AI、自检与旧版兼容代码。

## 一键推送代码

双击 `push_to_github.bat`，将指定源码、构建脚本与 README 提交并推送至 [Bling-sun/PlanTool](https://github.com/Bling-sun/PlanTool)。脚本只暂存固定文件列表，拒绝不匹配的 origin，不执行 force push，不会自动处理冲突。需要 Git、GitHub 写入权限及可用网络；首次使用可能需要 GitHub 登录。

代理设置为本机仓库的 Git 配置，不写入源码或脚本。换电脑或代理端口变化时，可用 `git config http.proxy ...` 更新，或用 `git config --unset http.proxy` 移除。
