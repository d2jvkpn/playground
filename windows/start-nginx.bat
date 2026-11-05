@echo on
cd /d D:\nginx

nginx.exe -t

nginx.exe -p D:/nginx/

echo.
echo Nginx startup command executed.
pause
