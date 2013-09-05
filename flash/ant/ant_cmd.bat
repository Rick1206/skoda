@echo off
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
call ant -version
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
call ant -buildfile "ant_tasks.xml"
pause