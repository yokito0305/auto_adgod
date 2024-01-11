@echo off

set commit_msg="upload_test_3"
git add .
git commit -m "%commit_msg%"
git push

pause