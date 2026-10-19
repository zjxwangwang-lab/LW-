@echo off
chcp 65001 >nul
cd /d "%~dp0"
set "LOG=%~dp0push-log.txt"

> "%LOG%" echo === push log %date% %time% ===

echo ============================================
echo   小芽启蒙 · 图片资源推送 (稳健版)
echo ============================================
echo.
echo 此脚本会按小批次分批推送到 GitHub，避免大 commit 推送超时
echo   批次1: shape_*.png + count_*.jpg  (11 张)
echo   批次2: word_*.webp                  (~814 张 / 约 164MB)
echo.

REM 检查 git
where git >nul 2>nul
if errorlevel 1 (
    echo [X] 没找到 Git
    pause
    exit /b 1
)

REM 配置 remote
git remote remove origin 2>nul
git remote add origin "https://github.com/zjxwangwang-lab/LW-.git"

echo [1] 推送 f9db68a (11 张)
echo.
git push origin f9db68a:main 2>>"%LOG%" 1>>"%LOG%"
if errorlevel 1 goto :fail

echo [2] 推送 225136f (814 张)
echo     约 164MB 首次推送需要 3-10 分钟，请耐心等待
echo     如果中途弹出登录窗口，请登录授权
echo.
git push origin 225136f:main 2>>"%LOG%" 1>>"%LOG%"
if errorlevel 1 goto :fail

echo.
echo ============================================
echo   全部推送成功！
echo   请告诉 Jason：「推送成功」
echo ============================================
echo.
echo 接下来你需要：
echo   1) 微信开发者工具里点「编译」
echo   2) 点「真机调试」扫码
echo   3) 手机上看到图片后，截图发给我
echo.
pause
exit /b 0

:fail
echo.
echo ============================================
echo   [X] 推送失败，详细日志：
echo ============================================
type "%LOG%"
echo.
echo 常见原因：
echo   1) 仓库未创建：去 https://github.com/new 创建 zjxwangwang-lab/LW- (Public)
echo   2) 没登录 GitHub：脚本会弹浏览器窗口，登录授权即可
echo   3) 仓库是 Private：jsDelivr 读不了，到 Settings 改成 Public
echo.
pause
exit /b 1
