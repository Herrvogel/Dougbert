@echo off
rem -------------------------------------------------------------------------
rem Research Study DICOM Moves (copies actually) from PACS
rem  Script for Windows
rem -------------------------------------------------------------------------
rem
rem Determine the number of patientIDs we have to process. Iterate once through the csv file to find out how many there are.
rem

date /t
time /t 

setlocal enableextensions enabledelayedexpansion

set /a count=1
set /a total_patients=0

for /F "tokens=1 delims=," %%c in (patient_IDS.csv) do (
	set /a total_patients+=1
rem	echo %%c
)
echo.
echo Total PatientIDs: !total_patients!
echo.

rem goto end

for /F "tokens=1 delims=," %%i in (patient_IDS.csv) do (

	Start "Image Copy" /d C:\ResearchStudies /high /wait /b movescu -b AE_RESEARCH@10.117.247.110:11114 -c QR_RESEARCH@10.148.101.69:7652  -m IssuerOfPatientID="*" -m Modality=MR -m StudyInstanceUID="*" -M StudyRoot -L SERIES --implicit-vr --dest AE_RESEARCH  -m PatientID=%%i  >> C:\ResearchStudies\%%i.log

	echo Copying Patient ID  %%i - !count! OF !total_patients!
	
	timeout /t 240 /nobreak
	
    IF %ERRORLEVEL% NEQ 0 (
		rename %%i.log FAILED_%%i.log
		echo.
		echo **************************************************
		echo FAILED: Processing of Patient ID %%i 
		echo **************************************************
		echo.
	)
	
	set /a count+=1
	echo.
	echo.
	echo.
)
endlocal
time /t
@echo on
rem exit