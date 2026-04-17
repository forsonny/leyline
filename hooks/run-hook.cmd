@echo off
setlocal

rem Leyline session-start launcher (Windows).
rem Called by the harness with a single argument naming the action to run.
rem Action "session-start" prints the entry skill (skills/using-leyline/SKILL.md)
rem to stdout so the harness injects it as system context.

rem Force the active code page to UTF-8 so non-ASCII characters in skill text
rem (smart quotes, em-dashes, accented characters) are not corrupted by the
rem default OEM code page.
chcp 65001 >nul

set "ACTION=%~1"
set "ROOT=%~dp0.."

if /I "%ACTION%"=="session-start" (
    type "%ROOT%\skills\using-leyline\SKILL.md"
    exit /b 0
)

echo Leyline hook: unknown action "%ACTION%" 1>&2
exit /b 1
