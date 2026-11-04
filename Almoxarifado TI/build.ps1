# Gera "Almoxarifado TI.html" juntando src/app.html com os dados iniciais da planilha (src/seed.json).
$root = $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)
$html = [IO.File]::ReadAllText((Join-Path $root 'src\app.html'), $utf8)
$seed = [IO.File]::ReadAllText((Join-Path $root 'src\seed.json'), $utf8) | ConvertFrom-Json | ConvertTo-Json -Depth 5 -Compress
$out = $html.Replace('__SEED__', $seed.Replace('</', '<\/'))
[IO.File]::WriteAllText((Join-Path $root 'Almoxarifado TI.html'), $out, $utf8)
"Gerado: Almoxarifado TI.html ($([math]::Round($out.Length / 1KB)) KB)"
