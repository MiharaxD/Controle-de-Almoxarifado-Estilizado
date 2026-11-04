# Gera "Almoxarifado TI.html" juntando src/app.html com os dados iniciais da planilha (src/seed.json) e os sons (src/som-maquina.mp3, src/som-papel.mp3, src/som-folha.mp3 e src/som-fogo.mp3, em base64).
$root = $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)
$html = [IO.File]::ReadAllText((Join-Path $root 'src\app.html'), $utf8)
$seed = [IO.File]::ReadAllText((Join-Path $root 'src\seed.json'), $utf8) | ConvertFrom-Json | ConvertTo-Json -Depth 5 -Compress
function Base64($arq) { [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $root $arq))) }
$out = $html.Replace('__SEED__', $seed.Replace('</', '<\/')).Replace('__SOM_PAPEL__', (Base64 'src\som-papel.mp3')).Replace('__SOM_FOLHA__', (Base64 'src\som-folha.mp3')).Replace('__SOM_FOGO__', (Base64 'src\som-fogo.mp3')).Replace('__SOM__', (Base64 'src\som-maquina.mp3'))
[IO.File]::WriteAllText((Join-Path $root 'Almoxarifado TI.html'), $out, $utf8)
"Gerado: Almoxarifado TI.html ($([math]::Round($out.Length / 1KB)) KB)"
