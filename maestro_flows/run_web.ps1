# Maestro Web 测试启动脚本
# 外置 chromedriver 解决 Maestro 内置驱动与本机 Chrome 版本不匹配的问题

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$maestroBin = Join-Path $projectRoot "maestro\bin"
$driver = Join-Path $projectRoot "chromedriver\chromedriver-win64\chromedriver.exe"
$flow = Join-Path $PSScriptRoot "web_smoke.yaml"

$env:MAESTRO_CLI_NO_ANALYTICS = "1"
$env:Path = "$env:Path;$maestroBin"
$env:JAVA_OPTS = "-Dwebdriver.chrome.driver=`"$driver`""

& "$maestroBin\maestro.bat" test $flow

