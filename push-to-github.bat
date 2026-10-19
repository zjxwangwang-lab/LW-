@echo off
chcp 65001 >nul
cd /d "%~dp0"
set "LOG=%~dp0push-log.txt"

> "%LOG%" echo === push log %date% %time% ===

echo ============================================
echo   小芽启蒙 · 图片资源一键推送到 GitHub (日志版)
echo ============================================
echo.

REM 1) 检查 git
where git >nul 2>nul
if errorlevel 1 (
    echo [X] 没找到 Git，请先安装：https://git-scm.com/download/win
    >>"%LOG%" echo [X] git not found
    pause
    exit /b 1
)
echo [1] Git 已就绪

REM 2) 初始化 + commit
if not exist ".git" (
    git init -b main >>"%LOG%" 2>&1
    git config user.name "LW"
    git config user.email "lw@local"
)
>>"%LOG%" echo --- git add ---
git add . >>"%LOG%" 2>&1
>>"%LOG%" echo --- git commit ---
git commit -m "init: xiaoya assets" >>"%LOG%" 2>&1
echo [2] 已 commit
echo.

REM 3) 推送到 GitHub
echo [3] 正在推送到 github.com/zjxwangwang-lab/LW-
echo     （约 900 张图片，首次可能需要 1-3 分钟，请耐心等待）
echo     如果弹出浏览器或登录窗口，请在里面登录 GitHub 授权
echo.
git remote remove origin 2>nul
git remote add origin "https://github.com/zjxwangwang-lab/LW-.git"
>>"%LOG%" echo --- git push ---
git push -u origin main >>"%LOG%" 2>&1
if errorlevel 1 (
    echo.
    echo ============================================
    echo   [X] 推送失败！详细原因如下：
    echo ============================================
    echo.
    type "%LOG%"
    echo.
    echo --------------------------------------------
    echo 常见原因：
    echo   1) 仓库不存在 - 请先到 github.com/new 创建，
    echo      用户名 zjxwangwang-lab，仓库名 LW-
    echo   2) 仓库是 Private - jsDelivr 只能读 Public 仓库，
    echo      到仓库 Settings 拉到底改 Public
    echo   3) 登录授权没完成 - 推送时会弹浏览器，要点授权
    echo --------------------------------------------
    echo.
    echo 请告诉 Jason：「推送失败」，他会读取日志自动处理
    pause
    exit /b 1
)

echo.
echo ============================================
echo   推送成功！
echo   请告诉 Jason：「推送成功」
echo ============================================
pause
