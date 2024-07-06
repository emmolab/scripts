@echo off

REM Command 1: Set AssumeUDPEncapsulationContextOnSendRule
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule /t REG_DWORD /d 0x2 /f

REM Command 2: Disable ProhibitIpSec
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\RasManParameters /v ProhibitIpSec /t REG_DWORD /d 0x0 /f
