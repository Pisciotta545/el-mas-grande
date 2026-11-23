# Genera el APK con el nombre <NombreApp>-v<versión>.apk (o -debug) y borra los nombres por defecto de Flutter.
# El nombre sale de android:label del AndroidManifest y la versión de pubspec.yaml.
#   .\build_apk.ps1          -> ElMasGrande-v1.0.0.apk
#   .\build_apk.ps1 -Debug   -> ElMasGrande-v1.0.0-debug.apk
param([switch]$Debug)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$version = (Select-String -Path pubspec.yaml -Pattern '^version:\s*([0-9.]+)').Matches[0].Groups[1].Value
$label = (Select-String -Path android/app/src/main/AndroidManifest.xml -Pattern 'android:label="([^"]+)"').Matches[0].Groups[1].Value

# "El más grande" -> "ElMasGrande": sin tildes, cada palabra con mayúscula, sin espacios.
$plain = $label.Normalize([Text.NormalizationForm]::FormD) -replace '\p{Mn}', ''
$appName = (($plain -split '\s+') | Where-Object { $_ } | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1) }) -join ''

$mode = if ($Debug) { 'debug' } else { 'release' }
$suffix = if ($Debug) { '-debug' } else { '' }
$finalName = "$appName-v$version$suffix.apk"

# Solo procesadores de celular (ARM): los x86_64 son de emuladores y casi duplican el tamaño.
flutter build apk "--$mode" --target-platform android-arm,android-arm64
if ($LASTEXITCODE -ne 0) { throw "flutter build apk --$mode falló" }

$flutterOut = 'build/app/outputs/flutter-apk'
$gradleOut = "build/app/outputs/apk/$mode"

# Se renombra (no se copia) y se borran los archivos con nombre por defecto.
Move-Item -Force "$flutterOut/app-$mode.apk" "$flutterOut/$finalName"
Remove-Item -Force -ErrorAction SilentlyContinue "$flutterOut/app-$mode.apk.sha1"
Get-ChildItem $flutterOut -Filter *.apk | Where-Object { $_.Name -ne $finalName } | Remove-Item -Force
if (Test-Path $gradleOut) { Remove-Item -Recurse -Force $gradleOut }

$left = @(Get-ChildItem $flutterOut -File)
if ($left.Count -ne 1 -or $left[0].Name -ne $finalName) {
    throw "En $flutterOut quedaron archivos de más: $($left.Name -join ', ')"
}
$size = [math]::Round($left[0].Length / 1MB, 1)
Write-Host "Listo: $flutterOut/$finalName ($size MB)"
