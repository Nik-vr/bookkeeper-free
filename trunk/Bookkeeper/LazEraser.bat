@echo off
echo -----------------------------------------------
echo Written By Nik (http://petrochenko.ru)
echo -=    Lazarus work-files erasor   =-
echo -----------------------------------------------
echo Erase files with mask *.tmp
del *.tmp
echo Erase compiled units
del *.a
del *.lfm
del *.o
del *.or
del *.ppu
del *.compiled
del *.res
echo Erase .app directory
del *.*.app
echo Erase debug info
del *.dbg
del *.rst
echo -----------------------------------------------