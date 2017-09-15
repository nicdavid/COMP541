@echo off
set xv_path=E:\\Vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim Lab2_Part4_test_8bit_behav -key {Behavioral:sim_7:Functional:Lab2_Part4_test_8bit} -tclbatch Lab2_Part4_test_8bit.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
