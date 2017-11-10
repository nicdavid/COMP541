@echo off
set xv_path=E:\\Vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim project_screentest_behav -key {Behavioral:sim_1:Functional:project_screentest} -tclbatch project_screentest.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
