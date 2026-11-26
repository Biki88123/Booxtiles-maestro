# BooxTiles Maestro Web 自动化测试

基于 [Maestro](https://github.com/mobile-dev-inc/Maestro) 的 Web 端 UI 自动化用例仓库，当前覆盖 BooxTiles 测试站点的冒烟场景。

## 目录结构

```
.
├── .gitignore                  # 排除大文件、账号文件、临时产物
├── maestro_flows/
│   ├── web_smoke.yaml          # 主冒烟用例（打开站点 → 断言 → 点击登录）
│   ├── demo_operations.yaml    # 常用操作演示（点击、滚动、截图等）
│   ├── run_web.ps1            # 一键运行脚本（内置外置 chromedriver 配置）
│   └── 用例编写说明书.md       # 完整的 Maestro 语法与用例编写指南
└── README.md
```

## 环境要求

| 依赖 | 版本 | 说明 |
|---|---|---|
| Windows | 10/11 | 当前在 Windows 11 验证 |
| Java | 17+ | Maestro CLI 运行依赖，本机为 21.0.8 |
| Maestro CLI | 2.12.1 | 安装见下方 |
| Chrome | 158.x | 本机浏览器 |
| chromedriver | 158.0.8127.88 | 外置驱动，解决内置驱动版本不匹配 |

> 说明：Maestro 的 Web 能力目前是 Beta，仅支持 Chromium 内核（Chrome/Edge）。复杂 Web 回归建议使用 Playwright，本项目用于轻量冒烟。

## 安装部署

### 1. 安装 Maestro CLI

从 GitHub Releases 下载 `maestro.zip`：
https://github.com/mobile-dev-inc/Maestro/releases

解压到本地目录（例如项目内 `maestro/`），确认 `bin/maestro.bat` 存在，并把 `bin` 目录加入系统 PATH。

验证：

```powershell
maestro --version
```

### 2. 外置 chromedriver（关键）

Maestro 内置驱动只支持 Chrome 134，与本机 Chrome 158 不匹配，必须外置：

1. 从 Chrome for Testing 下载对应版本 chromedriver：
   https://googlechromelabs.github.io/chrome-for-testing/
2. 解压得到 `chromedriver.exe`
3. 放到固定目录（例如项目内 `chromedriver/chromedriver-win64/chromedriver.exe`）
4. 运行用例时通过 JVM 参数注入（已封装在 `run_web.ps1`）：

```powershell
$env:JAVA_OPTS = '-Dwebdriver.chrome.driver="你的chromedriver路径"'
```

> Chrome 升级后需要重新下载匹配版本的 chromedriver 覆盖旧文件。

## 运行用例

### 方式一：一键脚本（推荐）

```powershell
powershell -ExecutionPolicy Bypass -File "H:\Study\BooxTilesAutoTest\maestro_flows\run_web.ps1"
```

成功输出：

```
Launch app "https://nano-dev-us.boox.com/"... COMPLETED
Assert that "Import books" is visible... COMPLETED
Tap on "Sign in"... COMPLETED
```

> 如果报"禁止运行脚本"，必须用上面的 `powershell -ExecutionPolicy Bypass -File` 方式。

### 方式二：直接用 CLI

```powershell
$env:JAVA_OPTS = '-Dwebdriver.chrome.driver="H:\Study\BooxTilesAutoTest\chromedriver\chromedriver-win64\chromedriver.exe"'
maestro test maestro_flows/web_smoke.yaml
```

### 调试辅助命令

```powershell
maestro check-syntax web_smoke.yaml   # 检查语法
maestro hierarchy                     # 打印页面元素层级（找 id/text 用）
maestro studio                        # 可视化点选元素生成 YAML
```

失败截图与日志目录：`C:\Users\Administrator\.maestro\tests\`（按时间命名）。

## 当前用例

### web_smoke.yaml

```yaml
url: https://nano-dev-us.boox.com/
---
- launchApp
- assertVisible: "Import books"
- tapOn: "Sign in"
```

流程：打开测试站点 → 断言首页可见 → 点击登录按钮。

## 编写新用例

详细语法见 `maestro_flows/用例编写说明书.md`，涵盖：

- 元素定位（文本 / id / 正则 / 坐标）
- 点击、双击、长按、滑动、滚动
- 键盘输入（`inputText`、`pressKey`、`eraseText`）
- 断言（`assertVisible`、`assertNotVisible`、`extendedWaitUntil`）
- 流程控制（`repeat`、`runFlow`、`retry`）

基本结构：

```yaml
url: https://nano-dev-us.boox.com/
---
- launchApp
- assertVisible: "Home"
- tapOn: "Import books"
```

**经验**：断言要用页面层级里实际存在的完整文本元素，不要凭截图上的视觉整句写。例如站点标题在 DOM 里被拆成 "BOOX ·" 和 "Tiles" 两个元素，整串 "Boox Tiles" 匹配不到；而 "Import books"、"Sign in" 这类完整文本节点才是稳定断言对象。用 `maestro hierarchy` 查看真实元素。

## 安全提示

- 测试账号、验证码等敏感信息**禁止提交到仓库**，已通过 `.gitignore` 排除（`测试地址和测试账号` 文件）
- Maestro CLI、chromedriver 等大文件也已排除（GitHub 单文件上限 100MB）
- 建议仓库设为 Private

## 仓库地址

https://github.com/Biki88123/Booxtiles-maestro
