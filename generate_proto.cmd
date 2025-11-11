@echo off
setlocal enabledelayedexpansion
SET SCRIPT_DIR=%~dp0

SET PROTOC_EXE=%SCRIPT_DIR%.build_ue5\third_party\protobuf\Release\protoc.exe
if not exist "%PROTOC_EXE%" (
    echo ERROR: protoc.exe not found. Please run build_for_ue5.ps1 first
    exit /b 1
)

SET GRPC_CPP_PLUGIN=%SCRIPT_DIR%.build_ue5\Release\grpc_cpp_plugin.exe
if not exist "%GRPC_CPP_PLUGIN%" (
    echo ERROR: grpc_cpp_plugin.exe not found. Please run build_for_ue5.ps1 first
    exit /b 1
)

if "%~1"=="" (
    echo Usage: generate_proto.cmd [PROTO_SRC_DIR] [OUTPUT_DIR]
    exit /b 1
)

SET PROTO_SRC_DIR=%~1
if not exist "%PROTO_SRC_DIR%" (
    echo ERROR: Proto source directory does not exist: %PROTO_SRC_DIR%
    exit /b 1
)

if "%~2"=="" (
    echo Usage: generate_proto.cmd [PROTO_SRC_DIR] [OUTPUT_DIR]
    exit /b 1
)

SET OUTPUT_DIR=%~2
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

set ERROR_COUNT=0

for /r "%PROTO_SRC_DIR%" %%f in (*.proto) do (
    echo Processing: %%~nxf
    "%PROTOC_EXE%" ^
        -I "%PROTO_SRC_DIR%" ^
        --cpp_out="%OUTPUT_DIR%" ^
        --grpc_out="%OUTPUT_DIR%" ^
        --plugin=protoc-gen-grpc="%GRPC_CPP_PLUGIN%" ^
        "%%f"

    if errorlevel 1 (
        echo ERROR: Failed to generate %%~nxf
        set /a ERROR_COUNT+=1
    )
)

if %ERROR_COUNT% gtr 0 exit /b 1
echo Done.
