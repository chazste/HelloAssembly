@setlocal

@rem Set LIBDIR to the directory containing the import libs for 
@rem kernel32 gdi32 and user32. You must use the SDK import libraries 
@rem for crinkler to work. If you use the masm32 libs the link
@rem version will be 32 bytes smaller.

@set LIBDIR="C:\Program Files (x86)\Windows Kits\10\\lib\10.0.22000.0\um\x86"
@rem @set LIBDIR="C:\masm32\lib"

@if not exist %LIBDIR%\user32.lib (
	@echo Set SDK LIB correctly
	exit /b 1
)

@rem Assemble
ml /c /coff /IC:\masm32\include Tiny.asm 

@rem Link with the Microsoft linker
link /LIBPATH:%LIBDIR% /NODEFAULTLIB:LIBCMT.lib /ENTRY:MainEntry /DEBUG:NONE /subsystem:windows /map /merge:.rdata=.text /merge:.data=.text /align:16 gdi32.lib user32.lib kernel32.lib tiny.obj

@rem Link using crinkler if the 'c' option passed on command line
if xc == x%1 (
	..\crinkler\crinkler.exe /LIBPATH:%LIBDIR% /ENTRY:MainEntry /SUBSYSTEM:WINDOWS /TINYHEADER /NOINITIALIZERS /UNSAFEIMPORT /ORDERTRIES:2000 /TINYIMPORT tiny.obj kernel32.lib user32.lib gdi32.lib /OUT:tiny-cr.exe
)
