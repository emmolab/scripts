@echo off

rem Add registry values for Microsoft Exchange
reg add HKCU\Software\Microsoft\Exchange /v AlwaysUseMSOAuthForAutoDiscover /t REG_DWORD /d 1 /f

rem Add registry values for Microsoft Office 16
reg add HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Identity /v EnableADAL /t REG_DWORD /d 1 /f
reg add HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Identity /v Version /t REG_DWORD /d 1 /f

rem Add registry values for Microsoft Office 15
reg add HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Identity /v EnableADAL /t REG_DWORD /d 1 /f
reg add HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Identity /v Version /t REG_DWORD /d 1 /f

rem Add registry values for Microsoft Office 14
reg add HKCU\SOFTWARE\Microsoft\Office\14.0\Common\Identity /v EnableADAL /t REG_DWORD /d 1 /f
reg add HKCU\SOFTWARE\Microsoft\Office\14.0\Common\Identity /v Version /t REG_DWORD /d 1 /f

echo Registry values added successfully.