@echo off
set xv_path=E:\\Vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim CounterMod7Enable_test_behav -key {Behavioral:sim_3:Functional:CounterMod7Enable_test} -tclbatch CounterMod7Enable_test.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
