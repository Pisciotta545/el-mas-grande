# Publica una versión nueva de la app: genera el APK y lo sube como Release de GitHub.
# Las apps instaladas la detectan solas al abrirse y ofrecen actualizar.
#
# Antes de publicar, subí la versión en pubspec.yaml (por ejemplo 1.1.0+2 -> 1.2.0+3):
# el número antes del "+" es el que ve la gente y el de después tiene que crecer siempre.
#   .\publicar.ps1 -Notas "Qué cambió en esta versión"
param([Parameter(Mandatory = $true)][string]$Notas)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$version = (Select-String -Path pubspec.yaml -Pattern '^version:\s*([0-9.]+)').Matches[0].Groups[1].Value
$tag = "v$version"

gh release view $tag 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    throw "La versión $tag ya está publicada. Subí la versión en pubspec.yaml antes de publicar."
}

flutter test
if ($LASTEXITCODE -ne 0) { throw 'Fallaron las pruebas: no se publica.' }

.\build_apk.ps1
$apk = Get-ChildItem build/app/outputs/flutter-apk -Filter *.apk | Select-Object -First 1

gh release create $tag $apk.FullName --title "El más grande $version" --notes $Notas
if ($LASTEXITCODE -ne 0) { throw 'No se pudo crear la Release en GitHub.' }
Write-Host "Publicada $tag con $($apk.Name). Las apps instaladas la van a ofrecer al abrirse."
