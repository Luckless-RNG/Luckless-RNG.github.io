@echo off
setlocal EnableDelayedExpansion

rem ==============================
rem  Rarity Generator - Batch port
rem ==============================

rem ----- Configuration -----
set "luckMultiplier=1100"
set "historyCount=0"
set "maxHistory=10"
set "bestTier=Common"
set "bestRank=0"

rem ----- Data: outcomes (name|tier|weight) -----
set i=0
set "outcome[0]=Common|Common|1000" & set /a i+=1
set "outcome[1]=Uncommon|Uncommon|800" & set /a i+=1
set "outcome[2]=Good|Good|600" & set /a i+=1
set "outcome[3]=Better|Better|400" & set /a i+=1
set "outcome[4]=Rare|Rare|300" & set /a i+=1
set "outcome[5]=Rarer|Rarer|200" & set /a i+=1
set "outcome[6]=Ultra Rare|UltraRare|150" & set /a i+=1
set "outcome[7]=Legendary|Legendary|100" & set /a i+=1
set "outcome[8]=Apex|Apex|80" & set /a i+=1
set "outcome[9]=Heavenly|Heavenly|60" & set /a i+=1
set "outcome[10]=Advanced|Advanced|50" & set /a i+=1
set "outcome[11]=Half god|HalfGod|40" & set /a i+=1
set "outcome[12]=God|God|30" & set /a i+=1

rem Scaled A-Z
set "outcome[13]=A Scaled|Scaled|20" & set /a i+=1
set "outcome[14]=B Scaled|Scaled|20" & set /a i+=1
set "outcome[15]=C Scaled|Scaled|20" & set /a i+=1
set "outcome[16]=D Scaled|Scaled|20" & set /a i+=1
set "outcome[17]=E Scaled|Scaled|20" & set /a i+=1
set "outcome[18]=F Scaled|Scaled|20" & set /a i+=1
set "outcome[19]=G Scaled|Scaled|20" & set /a i+=1
set "outcome[20]=H Scaled|Scaled|20" & set /a i+=1
set "outcome[21]=Void|Space|2" & set /a i+=1
set "outcome[22]=Black Hole|Space|2" & set /a i+=1
set "outcome[23]=Singularity|Space|2" & set /a i+=1
set "outcome[24]=Alpha|Greek|15" & set /a i+=1
set "outcome[25]=Beta|Greek|15" & set /a i+=1
set "outcome[26]=Gamma|Greek|15" & set /a i+=1
set "outcome[27]=Delta|Greek|15" & set /a i+=1
set "outcome[28]=Omega|Greek|15" & set /a i+=1
set "outcome[29]=Aleph Null|Aleph|10" & set /a i+=1
set "outcome[30]=Infinity|Infinity|10" & set /a i+=1
set "outcome[31]=Base Reality|Reality|1" & set /a i+=1
set "outcome[32]=The Backrooms|Reality|1" & set /a i+=1
set "outcome[33]=Absolute Infinity|Ellipsis|0" & set /a i+=1
set "outcome[34]=Shadow Nexus|Secret|0" & set /a i+=1
set "outcome[35]=Oblivion Core|Secret|0" & set /a i+=1

set /a "totalOutcomes=i-1"

rem ----- Reaction messages -----
set "react[Common]=Not bad!"
set "react[Uncommon]=Nice!"
set "react[Good]=Good one!"
set "react[Better]=Better!"
set "react[Rare]=Pretty rare!"
set "react[Rarer]=Even rarer!"
set "react[UltraRare]=Ultra rare!"
set "react[Legendary]=Legendary!"
set "react[Apex]=Apex tier!"
set "react[Heavenly]=Heavenly!"
set "react[Advanced]=Advanced!"
set "react[HalfGod]=Half god status!"
set "react[God]=God tier!"
set "react[Scaled]=Scaled up!"
set "react[Greek]=Greek letter!"
set "react[Aleph]=Aleph number!"
set "react[Infinity]=Infinite!"
set "react[Omega]=Omega level!"
set "react[Space]=Crazy!"
set "react[Reality]=Reality bending!"
set "react[Ellipsis]=ABSOLUTE INFINITY!"
set "react[Secret]=SECRET TIER!!!"

rem ----- Luck bonus (scaled by 1000) -----
set "bonus[Common]=1"
set "bonus[Uncommon]=2"
set "bonus[Good]=3"
set "bonus[Better]=5"
set "bonus[Rare]=10"
set "bonus[Rarer]=20"
set "bonus[UltraRare]=30"
set "bonus[Legendary]=70"
set "bonus[Apex]=100"
set "bonus[Heavenly]=150"
set "bonus[Advanced]=200"
set "bonus[HalfGod]=300"
set "bonus[God]=500"
set "bonus[Scaled]=8"
set "bonus[Greek]=12"
set "bonus[Aleph]=25"
set "bonus[Infinity]=40"
set "bonus[Omega]=45"
set "bonus[Space]=60"
set "bonus[Reality]=80"
set "bonus[Ellipsis]=150"
set "bonus[Secret]=250"

rem ----- Tier ranking -----
set "rank[Common]=1"
set "rank[Uncommon]=2"
set "rank[Good]=3"
set "rank[Better]=4"
set "rank[Rare]=5"
set "rank[Rarer]=6"
set "rank[UltraRare]=7"
set "rank[Legendary]=8"
set "rank[Apex]=9"
set "rank[Heavenly]=10"
set "rank[Advanced]=11"
set "rank[HalfGod]=12"
set "rank[God]=13"
set "rank[Scaled]=14"
set "rank[Greek]=15"
set "rank[Aleph]=16"
set "rank[Infinity]=17"
set "rank[Omega]=18"
set "rank[Space]=21"
set "rank[Reality]=22"
set "rank[Ellipsis]=23"
set "rank[Secret]=24"

rem ----- Welcome message -----
cls
echo ================================
echo    Rarity Generator
echo ================================
echo.
echo Type "roll" to roll
echo Type "history" to see last 10 rolls
echo Type "best" to see your best roll
echo Type "exit" to quit
echo.

:loop
set /p "cmd=>"
if /i "%cmd%"=="roll" call :roll
if /i "%cmd%"=="history" call :showhistory
if /i "%cmd%"=="best" call :showbest
if /i "%cmd%"=="cls" cls
if /i "%cmd%"=="exit" goto :end
if not "%cmd%"=="" if /i not "%cmd%"=="roll" if /i not "%cmd%"=="history" if /i not "%cmd%"=="best" if /i not "%cmd%"=="cls" if /i not "%cmd%"=="exit" (
    echo Unknown command. Try "roll", "history", "best", or "exit"
    echo.
)
goto :loop

:roll
echo.
echo Rolling...
echo.

rem ---- Build adjusted total ----
set "adjTotal=0"
for /L %%n in (0,1,%totalOutcomes%) do (
    for /F "tokens=1,2,3 delims=|" %%a in ("!outcome[%%n]!") do (
        set "adjWeight=%%c"
        if %%c LSS 100 (
            set /a "adjWeight=%%c * %luckMultiplier% / 1000"
            if !adjWeight! LSS 1 set "adjWeight=1"
        )
        set /a "adjTotal+=!adjWeight!"
        set "adjW[%%n]=!adjWeight!"
    )
)

rem ---- Random selection ----
set /a "rand=%random% * 32768 + %random%"
set /a "rand=rand %% adjTotal"
set "selected=0"
set "cum=0"
for /L %%n in (0,1,%totalOutcomes%) do (
    set /a "cum+=!adjW[%%n]!"
    if !cum! GTR %rand% (
        set "selected=%%n"
        goto :selected
    )
)
:selected

rem ---- Retrieve result ----
for /F "tokens=1,2 delims=|" %%a in ("!outcome[%selected%]!") do (
    set "resultName=%%a"
    set "resultTier=%%b"
)

rem ---- Update history ----
set /a "historyCount+=1"
if %historyCount% GTR %maxHistory% (
    for /L %%h in (1,1,9) do (
        set /a "nextH=%%h+1"
        set "hist%%h=!hist!nextH!!"
    )
    set "historyCount=10"
)
set "hist%historyCount%=!resultName!"

rem ---- Update best roll ----
if !rank[%resultTier%]! GTR %bestRank% (
    set "bestName=!resultName!"
    set "bestTier=!resultTier!"
    set "bestRank=!rank[%resultTier%]!"
)

rem ---- Apply luck bonus ----
set "b=!bonus[%resultTier%]!"
set /a "luckMultiplier+=b"

rem ---- Display result ----
echo You got...
echo !resultName!
echo !react[%resultTier%]!
set /a "luckPct=(luckMultiplier-1000)/10"
set /a "bonusPct=b/10"
echo +!bonusPct!%% luck! (Total: !luckPct!%%)
echo.
goto :eof

:showhistory
echo.
if %historyCount% EQU 0 (
    echo No rolls yet!
) else (
    echo Last %historyCount% rolls:
    for /L %%h in (1,1,%historyCount%) do (
        echo   %%h. !hist%%h!
    )
)
echo.
goto :eof

:showbest
echo.
if %bestRank% EQU 0 (
    echo No rolls yet!
) else (
    echo Your best roll:
    echo   !bestName!
)
echo.
goto :eof

:end
echo.
echo Thanks for playing!
pause
exit