@echo off
set xv_path=E:\\Vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim vgatimer_10x4_test_behav -key {Behavioral:sim_1:Functional:vgatimer_10x4_test} -tclbatch vgatimer_10x4_test.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
