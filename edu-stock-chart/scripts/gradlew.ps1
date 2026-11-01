# gradlew.bat 대신 Gradle Wrapper 를 java 로 직접 실행한다
# .bat 실행이 막힌 PC(액세스 거부 · Smart App Control · 백신)나 LF 줄바꿈으로 받은 gradlew.bat 에서도 동작
# 사용: & .\scripts\gradlew.ps1 clean bootJar -q
$AppHome = Split-Path -Parent $PSScriptRoot
$Jar = Join-Path $AppHome 'gradle\wrapper\gradle-wrapper.jar'

# gradlew.bat 과 같은 순서: JAVA_HOME → PATH 의 java
$Java = $null
if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) { $Java = Join-Path $env:JAVA_HOME 'bin\java.exe' }
if (-not $Java) { $Java = (Get-Command java -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1).Source }
if (-not $Java) { Write-Host '[X] java 를 찾지 못했습니다. JDK 21 을 설치하거나 JAVA_HOME 을 지정하세요'; exit 1 }
if (-not (Test-Path $Jar)) { Write-Host "[X] $Jar 가 없습니다"; exit 1 }

Push-Location $AppHome
try {
  & $Java '-Xmx64m' '-Xms64m' '-Dorg.gradle.appname=gradlew' -classpath $Jar org.gradle.wrapper.GradleWrapperMain @args
  $code = $LASTEXITCODE
} finally { Pop-Location }
exit $code
