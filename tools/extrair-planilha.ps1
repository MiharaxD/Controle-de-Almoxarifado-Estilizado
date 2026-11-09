# Extrai os patrimonios e o descarte da planilha para src/seed.json (dados brutos; a normalizacao fica em buildInitialDb no app).
# Uso: & ".\tools\extrair-planilha.ps1" [-Planilha caminho.xlsx] [-Relatorio]
# Depois rode build.ps1 para gerar o HTML. O seed so vale para banco vazio ou "Restaurar dados da planilha".
param(
  [string]$Planilha = (Join-Path (Split-Path $PSScriptRoot) 'Controle de almoxarifado TI SASC.xlsx'),
  [switch]$Relatorio
)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)
$tmp = Join-Path ([IO.Path]::GetTempPath()) ('almox-xlsx-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory $tmp | Out-Null
try {
  # ---------- xlsx -> grade de celulas (sem formulas) ----------
  Copy-Item $Planilha "$tmp\p.zip"
  Expand-Archive "$tmp\p.zip" "$tmp\x"
  $d = "$tmp\x"
  [xml]$ss = Get-Content -Raw -Encoding UTF8 "$d\xl\sharedStrings.xml"
  $strings = New-Object System.Collections.Generic.List[string]
  foreach ($si in $ss.sst.si) { $strings.Add($si.InnerText) }
  [xml]$wb = Get-Content -Raw -Encoding UTF8 "$d\xl\workbook.xml"
  [xml]$rels = Get-Content -Raw -Encoding UTF8 "$d\xl\_rels\workbook.xml.rels"
  $map = @{}; foreach ($r in $rels.Relationships.Relationship) { $map[$r.Id] = $r.Target }
  function ColIdx($ref) { $l = ($ref -replace '\d', ''); $n = 0; foreach ($ch in $l.ToCharArray()) { $n = $n * 26 + ([int][char]$ch - 64) }; $n }
  function CellVal($c) {
    $v = $null
    if ($c.t -eq 's' -and $c.v) { $v = $strings[[int]$c.v] }
    elseif ($c.t -eq 'inlineStr') { $v = $c.is.InnerText }
    elseif ($c.v) { $v = [string]$c.v; if ($v -match '^\d+\.0$') { $v = $v -replace '\.0$', '' } }
    if ($null -ne $v) { $v = "$v".Trim() }
    $v
  }
  $result = [ordered]@{}
  foreach ($s in $wb.workbook.sheets.sheet) {
    $rid = $s.GetAttribute('id', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships')
    [xml]$x = Get-Content -Raw -Encoding UTF8 (Join-Path "$d\xl" $map[$rid])
    $grid = @{}
    foreach ($row in $x.worksheet.sheetData.row) {
      $ri = [int]$row.r
      foreach ($c in $row.c) {
        if ($c.f) { continue }
        $v = CellVal $c
        if ($v) { if (-not $grid[$ri]) { $grid[$ri] = @{} }; $grid[$ri][(ColIdx $c.r)] = $v }
      }
    }
    $rowsOut = @()
    foreach ($ri in ($grid.Keys | Sort-Object)) {
      $o = [ordered]@{ r = $ri }
      foreach ($ci in ($grid[$ri].Keys | Sort-Object)) { $o["$ci"] = $grid[$ri][$ci] }
      $rowsOut += $o
    }
    $result[$s.name] = $rowsOut
  }
  # ida e volta por JSON: deixa cada linha como objeto com propriedades "r", "1", "2"...
  $g = $result | ConvertTo-Json -Depth 6 -Compress | ConvertFrom-Json

  # ---------- grade -> registros ----------
  # Linha 1 de cada aba: nome da unidade no inicio de cada bloco; linha 2: nomes dos campos.
  function Row($sheet, $r) { $g.$sheet | Where-Object { $_.r -eq $r } | Select-Object -First 1 }
  function Props($o) { $h = @{}; foreach ($p in $o.PSObject.Properties) { if ($p.Name -ne 'r') { $h[[int]$p.Name] = [string]$p.Value } }; $h }
  # busca campo por regex para nao depender de acentos neste arquivo (PS 5.1 le .ps1 sem BOM como ANSI)
  function F($rec, $re) { foreach ($k in $rec.Keys) { if ($k -match $re -and $rec[$k]) { return $rec[$k] } }; $null }
  function UnitName($raw) {
    $u = ($raw -replace '\s+', ' ').Trim().ToUpper()
    switch ($u) { 'ESTOQUE' { 'Estoque TI' } 'SEMASC' { 'SASC' } default { $u } }
  }
  $items = New-Object System.Collections.Generic.List[object]
  $sheets = @(
    @{ name = 'CPU'; cat = $null },
    @{ name = 'MONITOR'; cat = 'Monitor' },
    @{ name = 'IMPRESSORA'; cat = 'Impressora' },
    @{ name = 'Estabilizador'; cat = 'Estabilizador' },
    @{ name = 'Outros'; cat = $null }
  )
  foreach ($sh in $sheets) {
    $hdr = Props (Row $sh.name 1); $fld = Props (Row $sh.name 2)
    $starts = @($hdr.Keys | Sort-Object)
    for ($bi = 0; $bi -lt $starts.Count; $bi++) {
      $c0 = $starts[$bi]; $c1 = if ($bi + 1 -lt $starts.Count) { $starts[$bi + 1] - 1 } else { 999 }
      $unit = UnitName $hdr[$c0]
      $cols = @($fld.Keys | Where-Object { $_ -ge $c0 -and $_ -le $c1 -and $fld[$_] -notmatch '^(?i)total' })
      foreach ($row in ($g.($sh.name) | Where-Object { $_.r -ge 3 })) {
        $p = Props $row; $rec = @{}
        foreach ($c in $cols) { if ($p.ContainsKey($c)) { $rec[$fld[$c]] = $p[$c] } }
        if (-not ($rec['Produto'] -or $rec['Marca'])) { continue }
        if ($rec['Produto'] -match '^(?i)total') { continue }
        $items.Add([pscustomobject]@{
          sheet = $sh.name; unidade = $unit; setor = $rec['Setor']
          produto = if ($sh.cat) { $sh.cat } else { $rec['Produto'] }
          marca = if ($sh.name -eq 'IMPRESSORA') { $rec['Produto'] } else { if ($rec['Marca']) { $rec['Marca'] } else { $rec['Modelo'] } }
          modelo = if ($sh.name -eq 'IMPRESSORA') { $rec['Modelo'] } else { $null }
          tipo = $rec['Tipo']; pat = (F $rec '^Patrim'); obs = (F $rec '^Observa')
          proto = (F $rec '^Protocolo')
        })
      }
    }
  }
  $desc = foreach ($row in ($g.Descarte | Where-Object { $_.r -ge 2 })) {
    $p = Props $row
    if (-not $p[2]) { continue }
    [pscustomobject]@{ proto = $p[1]; produto = $p[2]; pat = $p[3]; detalhes = $p[4] }
  }
  $json = [pscustomobject]@{ items = $items; descarte = @($desc) } | ConvertTo-Json -Depth 5 -Compress
  [IO.File]::WriteAllText((Join-Path $root 'src\seed.json'), $json, $utf8)
  "Gerado: src\seed.json (patrimonios: $($items.Count), descarte: $(@($desc).Count))"

  if ($Relatorio) {
    "--- registros por aba e unidade"; $items | Group-Object sheet, unidade | Select-Object Count, Name | Format-Table -AutoSize | Out-String -Width 200
    "--- produtos"; $items | Group-Object produto | Select-Object Count, Name | Format-Table -AutoSize | Out-String
    "--- patrimonios fora do padrao 5-6 digitos"; $items | Where-Object { $_.pat -notmatch '^\d{5,6}$' } | ForEach-Object { "$($_.sheet)|$($_.unidade)|$($_.produto)|$($_.tipo)|[$($_.pat)]" } | Sort-Object -Unique
    "--- patrimonios repetidos"; $items | Where-Object { $_.pat -match '^\d{5,6}$' } | Group-Object pat | Where-Object Count -gt 1 | ForEach-Object { "$($_.Name): " + (($_.Group | ForEach-Object { "$($_.produto)@$($_.unidade)/$($_.setor)" }) -join ' ; ') }
    "--- descarte fora do padrao"; $desc | Where-Object { $_.pat -notmatch '^\d{5,6}$' } | ForEach-Object { "$($_.produto)|[$($_.pat)]|$($_.detalhes)" }
  }
}
finally { Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue }
