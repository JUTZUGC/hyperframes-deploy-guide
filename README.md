# HyperFrames 一键安装指南

> 第三方部署指南 · 非 HyperFrames 官方仓库。官方项目：[heygen-com/hyperframes](https://github.com/heygen-com/hyperframes)
> 内容来自官方文档（2026-10-26）。项目迭代快，请以[官方文档](https://github.com/heygen-com/hyperframes)为准。

[![⚡ 一键安装](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键安装推荐用百度搭子)

## 一键安装（推荐：用百度搭子）

> [!TIP]
> 不用自己配渲染环境，让百度搭子装好 CLI 和技能，之后让 AI 直接给你出片。

⚠️ 需要 Node.js 22+ 与 FFmpeg。装的是命令行 + 一组技能，没有网页界面；渲染走无头 Chrome，首次渲染会下载浏览器内核。官方桌面 App 目前只有 macOS / Linux。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/hyperframes-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会先检查 Node 与 FFmpeg，再全局装好 hyperframes，并把核心技能注册到客户端，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## HyperFrames 是什么？

HyperFrames 是开源的把 HTML 渲染成确定性 MP4 的开源框架（协议：Apache-2.0，<img src="https://img.shields.io/github/stars/heygen-com/hyperframes?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把 HTML、CSS、媒体和可定位动画渲染成确定的 MP4：本地 CLI 或 Agent 技能都能用，同一份输入每次出同样的视频；也能当自建视频生产流水线的渲染内核。

- 输入：HTML + CSS + 媒体 + 可 seek 动画
- 输出：MP4，渲染走无头 Chrome + FFmpeg
- 用法：`hyperframes init` 建项目、`hyperframes render` 出片
- Agent：`npx hyperframes skills update` 装核心技能，直接让 Agent 做视频
- 可复现：同一输入得到同样结果

（来源：[官方仓库](https://github.com/heygen-com/hyperframes)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 72.6k stars | Apache-2.0 开源，更新很勤 |
| 可复现 | 同一份 HTML 每次渲染结果一致 |
| Agent 友好 | 核心技能一条命令装好 |
| 两种用法 | 本地 CLI，或交给编码 Agent |
| 可容器化 | Docker 里也能渲染，方便批量出片 |

| 需要注意 | 说明 |
|---|---|
| 要会写 HTML/CSS | 纯小白做不了复杂效果 |
| 依赖 Node 22+ | 低版本直接装不上 |
| 还要 FFmpeg | 没装会卡在渲染 |
| 首次渲染慢 | 要下载无头浏览器内核 |
| 桌面 App 只有 macOS / Linux | Windows 目前只能走 CLI |

> 以上基于官方文档与社区反馈整理（2026-10-26），以官方最新文档为准。

## 快速部署（官方方式）

```bash
node -e "const [a]=process.versions.node.split('.').map(Number); if (a<22) { console.error('需要 Node.js 22 或更高，当前 '+process.versions.node); process.exit(1) }"
command -v ffmpeg >/dev/null 2>&1 || { echo "需要先安装 FFmpeg（macOS: brew install ffmpeg，Linux: apt install ffmpeg）"; exit 1; }
npm i -g hyperframes
hyperframes skills update
```

部署步骤来源：[https://github.com/heygen-com/hyperframes#quick-start](https://github.com/heygen-com/hyperframes#quick-start)

## 验证状态

| 场景 | 状态 |
|---|---|
| npm 安装 hyperframes 成功，版本 0.8.203 与最新 Release 一致 | 已验证 2026-10-26 |
| 本机 FFmpeg 可用；未实际渲染视频 | 已核对 2026-10-26 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-26 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-26 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

它不是 MCP server，而是 CLI + Agent 技能。本仓库的 MCP 只提供安装步骤、依赖检查与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-26）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\hyperframes-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装完成后：怎么用

```bash
hyperframes init my-video
cd my-video
npx hyperframes preview   # 浏览器里实时预览
npx hyperframes render    # 渲染成 MP4
```

### 让 Agent 做视频

```bash
npx hyperframes skills update
```

装完直接在客户端里说「用 HyperFrames 做一个 15 秒的产品介绍视频」，Agent 会调用对应技能。

> 渲染依赖无头 Chrome 与 FFmpeg：首次渲染可能要先下载浏览器内核；Docker 里也能渲染，适合放到服务器上批量出片。

## 常见坑

- Node 版本不够：需要 22+，先 `node -v` 确认
- 没装 FFmpeg：渲染会失败，Windows 用 `winget install Gyan.FFmpeg`
- `hyperframes` 命令找不到：全局安装后重开终端，或检查 npm 全局 bin 是否在 PATH
- 首次渲染卡住：在下载无头浏览器，等它完成；国内网络可配代理
- 技能没装上：用 `npx hyperframes skills update`，它只装核心四个技能
- 别把 `skills add --all` 当成默认：会装全部 7 个技能，多数人用不到
- 渲染很吃 CPU：长视频建议放服务器或 Docker 里跑

## 免责声明

本仓库为第三方指南，与 HyperFrames 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-26），项目迭代快，请以[官方文档](https://github.com/heygen-com/hyperframes)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
