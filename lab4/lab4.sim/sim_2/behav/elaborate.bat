@echo off
set xv_path=E:\\Vivado\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 59a115f261db49c49a7dbbad9fb7c9b3 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot displaydriver_10x4_test_behav xil_defaultlib.displaydriver_10x4_test xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
