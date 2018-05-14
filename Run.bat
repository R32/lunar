@echo off
cd bin
::@echo ----- nodejs ------
node test.js
@echo ----- neko ------
neko test.n
@echo ----- hl -------
hl test.hl
::start test.swf
pause
