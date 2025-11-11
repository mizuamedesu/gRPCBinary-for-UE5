# Build gRPC with /MD (dynamic CRT) for Unreal Engine 5.5

$ErrorActionPreference = "Stop"

$UE_THIRD_PARTY_DIR = "D:\UE_5.5_Source\Engine\Source\ThirdParty" # ソースからビルドしたUE5のThirdPartyディレクトリへのパスに変更
$BUILD_DIR = Join-Path $PSScriptRoot ".build_ue5"
$GRPC_DIR = Join-Path $PSScriptRoot "grpc"

Write-Host "Cleaning previous build..." -ForegroundColor Yellow
if (Test-Path $BUILD_DIR) {
    Remove-Item -Recurse -Force $BUILD_DIR
}
New-Item -ItemType Directory -Path $BUILD_DIR | Out-Null
Set-Location $BUILD_DIR

Write-Host ""
Write-Host "Configuring CMake with /MD runtime..." -ForegroundColor Yellow
Write-Host ""

$cmakeArgs = @(
    "$GRPC_DIR"
    "-G", "Visual Studio 17 2022"
    "-A", "x64"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CONFIGURATION_TYPES=Release"
    "-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL"
    "-DCMAKE_CXX_FLAGS_RELEASE=/MD /O2 /Ob2 /DNDEBUG"
    "-DCMAKE_C_FLAGS_RELEASE=/MD /O2 /Ob2 /DNDEBUG"
    "-Dprotobuf_BUILD_TESTS=OFF"
    "-Dprotobuf_MSVC_STATIC_RUNTIME=OFF"
    "-DgRPC_BUILD_TESTS=OFF"
    "-DgRPC_ZLIB_PROVIDER=package"
    "-DZLIB_INCLUDE_DIR=$UE_THIRD_PARTY_DIR\zlib\1.3\include"
    "-DZLIB_LIBRARY=$UE_THIRD_PARTY_DIR\zlib\1.3\lib\Win64\Release\zlibstatic.lib"
    "-DgRPC_SSL_PROVIDER=module"
)

& cmake $cmakeArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "CMake configuration failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Building gRPC with /MD runtime..." -ForegroundColor Yellow
Write-Host ""

& cmake --build . --target ALL_BUILD --config Release -j 8

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "Built libraries are in: $BUILD_DIR\Release" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to exit"
