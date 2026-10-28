# HyperFrames 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/heygen-com/hyperframes
# 更新日期：2026-10-28
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw '需要先安装 Node.js' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

node -e "const [a]=process.versions.node.split('.').map(Number); if (a<22) { console.error('需要 Node.js 22 或更高，当前 '+process.versions.node); process.exit(1) }"
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) { throw '需要先安装 FFmpeg（winget install Gyan.FFmpeg）' }
npm i -g hyperframes ; if ($LASTEXITCODE -ne 0) { throw '安装失败，请查看上面的输出' }
hyperframes skills update

Write-Host ''

Write-Host '安装完成：在空目录里执行 hyperframes init my-video，再 npx hyperframes preview 预览、npx hyperframes render 出 MP4'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/heygen-com/hyperframes'
