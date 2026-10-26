@echo off
chcp 65001 >nul
cd /d "%~dp0"
set "LOG=%~dp0push-log.txt"
set "PY=C:\Users\zjxwa\.workbuddy\binaries\python\envs\default\Scripts\python.exe"

> "%LOG%" echo === HD phrase push %date% %time% ===

echo ============================================
echo   小芽启蒙 · 高清短句图推送 (591 张 / 约34MB)
echo ============================================
echo.
echo 如果弹出 GitHub 登录/授权窗口，请按提示登录授权
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [X] 没找到 Git
    pause
    exit /b 1
)

REM 2026-10-26：本机代理下 git 默认走 HTTP/2 会 TLS 断连
REM   （schannel: server closed abruptly / CONNECT tunnel failed 502）
REM 强制 HTTP/1.1 后推送稳定。仓库级 config 已写入，这里再兜一层。
git config http.version HTTP/1.1

:retry
git push origin main 1>>"%LOG%" 2>&1
if errorlevel 1 (
    echo [!] 推送失败，10 秒后自动重试（代理网络波动，多试几次通常能过）...
    timeout /t 10 /nobreak >nul
    goto :retry
)

echo [OK] 推送成功！正在切换 CDN 到新版本...
for /f %%i in ('git rev-parse HEAD') do set SHA=%%i
"%PY%" "C:\Users\zjxwa\WorkBuddy\2026-09-07-08-53-13\update_cdn_sha.py" %SHA%
if errorlevel 1 goto :patchfail

echo.
echo ============================================
echo   全部完成！高清图已上线
echo ============================================
echo 接下来：
echo   1) 微信开发者工具点「编译」
echo   2) 真机调试扫码，进短句板块看图片是否变清晰
echo   3) 把结果告诉 Jason
echo.
pause
exit /b 0

:patchfail
echo [X] CDN 切换失败，把 push-log.txt 发给 Jason
pause
exit /b 1
