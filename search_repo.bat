:: BUSQUEDA DE FILES

:: variables
@echo off
setlocal EnableDelayedExpansion
set INPUT_FILE=list_repos_git
set RESULT_FILE="SEACRHING_RESULT"
set SEARCH_FOR="namespace=jaav"
set BRANCH=master
:: set OUT=init


::limpiando result existente:
mkdir result
rmdir src /s /q
del /q result\*
del /f %RESULT_FILE%.properties

::recorrer input source:
mkdir src
cd src
for /F "tokens=*" %%A in (../%INPUT_FILE%.txt) do  (	
	:: @echo %init% %%A b master
	:: @echo https://github.com/git-jaav/%%A.git
	:: rmdir %%A /s /q		
	git clone https://github.com/git-jaav/%%A.git -b %BRANCH%
	cd %%A		
	echo SEARCHING ON %%A	
	git grep -n %SEARCH_FOR% >> %%A.txt
	
	:: solo generar resultado para busqueda NO VACIA
	for /f %%i in (%%A.txt) do (
		if "%%i" == "" ( 
			echo LINEA VACIA	
		) else ( 
			echo LINEA NO VACIA
			echo # %%A: > ../../result/%%A			
			type %%A.txt >> ../../result/%%A
			echo. >> ../../result/%%A
		)	
	)	
	cd ..	
)
cd ..	

:: preparando resultado final:
cd result

echo #### RESULTADO FINAL ##### > ../%RESULT_FILE%.properties
echo. >> ../%RESULT_FILE%.properties
echo ## CANTIDAD DE REPOS ENCONTRADOS PARA: [%SEARCH_FOR%] :  >> ../%RESULT_FILE%.properties
dir /b /a-d | find /c /v "" >> ../%RESULT_FILE%.properties
echo. >> ../%RESULT_FILE%.properties
echo ## RESUMEN DE REPOS ENCONTRADOS: >> ../%RESULT_FILE%.properties
dir /b >> ../%RESULT_FILE%.properties

copy /b * RESULT.txt

echo. >> ../%RESULT_FILE%.properties
echo ## DETALLE DE REPOS ENCONTRADOS: >> ../%RESULT_FILE%.properties
type RESULT.txt >> ../%RESULT_FILE%.properties

:: echo RESULTADO & echo.%RESULT%