@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================
echo   小芽启蒙 · 图片资源一键推送到 GitHub
echo ============================================
echo.

REM 1) 检查 git
where git >nul 2>nul
if errorlevel 1 (
    echo [X] 没找到 Git，请先安装：https://git-scm.com/download/win
    pause
    exit /b 1
)
echo [1] Git 已就绪
echo.

REM 2) 初始化 + commit
if not exist ".git" (
    git init -b main
    git config user.name "LW"
    git config user.email "lw@local"
    echo [2] 已初始化 git 仓库
) else (
    echo [2] git 仓库已存在
)

REM 清掉 macOS 隐藏文件（Windows 上可能生成的）
del /q ".DS_Store" 2>nul

git add .
git commit -m "init: 小芽启蒙图片资源" -q
if errorlevel 1 (
    echo [警告] commit 失败或无变更
)
echo [3] 已 commit
echo.

REM 3) 推送到 GitHub
echo [4] 正在推送到 https://github.com/LW启蒙/LW启蒙仓.git
echo.
git remote remove origin 2>nul
git remote add origin "https://github.com/zijwangwang-lab/LW-.git"
git push -u origin main
if errorlevel 1 (
    echo.
    echo ============================================
    echo   推送失败！最常见原因：
    echo   1) 仓库 LW启蒙仓 不存在 — 请先去 https://github.com/new 创建
    echo   2) 仓库不是 Public（公开）— jsDelivr 只能读 Public 仓库
    echo   3) 远程地址里有中文 — 如果上面 "origin" 报错，先在浏览器
    echo      登录 GitHub，再到 https://github.com/settings/tokens
    echo      创建一个 fine-grained token（勾 Contents: Read and write），
    echo      推送时用 token 当密码
    echo ============================================
    pause
    exit /b 1
)

echo.
echo ============================================
echo   推送成功！
echo.
echo   接下来请告诉 Jason：「推送成功」，
echo   他会立即把代码里的 JSCDN_USER 替换成
echo   「LW启蒙」并让你重新编译测试。
echo ============================================
pause
