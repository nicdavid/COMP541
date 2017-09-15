@echo off
set xv_path=E:\\Vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim Lab3_Part4_test_32bit_behav -key {Behavioral:sim_8:Functional:Lab3_Part4_test_32bit} -tclbatch Lab3_Part4_test_32bit.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
