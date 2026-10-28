#!/usr/bin/env bash
set -euo pipefail
# HyperFrames 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/heygen-com/hyperframes
# 更新日期：2026-10-28
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

node -e "const [a]=process.versions.node.split('.').map(Number); if (a<22) { console.error('需要 Node.js 22 或更高，当前 '+process.versions.node); process.exit(1) }"
command -v ffmpeg >/dev/null 2>&1 || { echo "需要先安装 FFmpeg（macOS: brew install ffmpeg，Linux: apt install ffmpeg）"; exit 1; }
npm i -g hyperframes
hyperframes skills update

echo ""

echo "安装完成：在空目录里执行 hyperframes init my-video，再 npx hyperframes preview 预览、npx hyperframes render 出 MP4"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/heygen-com/hyperframes"
