:clink_init
    set _RELEASE_URL=https://api.github.com/repos/mridgers/clink/releases
    set ACCEPT=local global
    set ALLOW_EMPTY_LOCATION=1
    goto :eof

rem "browser_download_url": "https://github.com/mridgers/clink/releases/download/0.4.8/clink_0.4.8.zip"
:clink_versions
    set "regex=browser_download_url.*download\/[0-9]*\.[0-9]*\.[0-9]*\/clink_[0-9]*\.[0-9]*\.[0-9]*\.zip"
    FOR /L %%G IN (1,1,2) DO (
        ncall :BrickvDownload "%_RELEASE_URL%?page=%%G" "%VERSION_SOURCE_FILE%"
        FOR /F "tokens=* USEBACKQ" %%F IN (
                `FINDSTR  /R /C:"%regex%" %VERSION_SOURCE_FILE%`) DO (
            for /F "delims=: tokens=3" %%P in ("%%F") do (
                set TARGET_URL=https:%%P
            )
            for /F "delims=/ tokens=8" %%P in ("!TARGET_URL!") do (
                set TARGET_NAME=%%P
            )
            for /F "delims=_ tokens=2" %%A in ("!TARGET_NAME!") do (
                set CLINK_VER=%%A
            )
            echo.clink=!CLINK_VER![.]$!TARGET_URL:~0,-1!>> "%VERSION_SPCES_FILE%"

        )
    )
    goto :eof

:clink_prepare
	set APPVER=%MATCH_VER%
	if "%REQUEST_NAME%" == "" set REQUEST_NAME=clink-%APPVER%
	set DOWNLOAD_URL=%MATCH_CARRY%
	goto :eof

:clink_unpack
	set SETENV=%SETENV%;$SCRIPT_FOLDER$
	set UNPACK_METHOD=unzip
	goto :eof

:clink_validate
	set CHECK_EXIST=
	set CHECK_CMD=clink_x86
	set CHECK_LINEWORD=Copyright
	set CHECK_OK=Clink v%%VA_INFO_VERSION%%
	goto:eof
