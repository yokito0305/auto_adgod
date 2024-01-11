@echo off

set commit_msg="自動上傳測試2"

git add .
git commit -m "%commit_msg%"
git push

pause