# Rotas diretas por tipo de tarefa

Quase tudo está em `src/app.html` (~3.400 linhas: CSS no `<style>`, depois JS). **Não leia inteiro:** `grep "/\* ---------- "` lista as seções; leia só a que precisa.
Validação: sem testes automatizados. `& ".\build.ps1"`, sirva por `http://localhost:8765` e confira no navegador (inclusive largura de celular).

Fluxo: `init()` → `loadDb()` (IndexedDB; vazio → `buildInitialDb()` do seed) → `route()` lê `#/aba?params` → `render()` chama `VIEWS[aba]()` → cliques `[data-act]` → `ACTIONS`; campos `[data-in]`/`[data-ch]` → `INPUTS` → mudanças em `db` terminam em `commit()` (salva + redesenha o menu).

## Design, tema e layout
- **Ir direto para:** `DESIGN.md` e o `<style>`: tokens num único `:root` (só escuro); keyframes e `prefers-reduced-motion` antes dos `@media (max-width…)` no fim. Texturas de ruído (`--fibra`, `--manchas`, `--grain`, `--ink-mask`) são SVG caros; `texturas()` as troca por PNG em blob (textura nova entra na lista). Ícones SVG em `ICONS`.
- **Modais e gaveta** (seção `toasts, modal, drawer`): `openLayer`, `modal(title, body, foot, {wide, selo, tinta, cls})`, `closeLayer(saida)` (clona para `.layer-out` inerte que anima a saída; gaveta de papel usa `FOLHA_SAI[saida]`), `confirmDialog`. Clicar fora/Esc passa por `layerFora`: só fecha se `ui.layerSujo` é falso (marcado por `marcaSujo`); quem reabre o modal no lugar preserva `ui.layerSujo`.
- **Cuidados:** cor nova = token novo. `.papel` redefine os tokens para tinta sobre papel. Status são carimbos `b-ok/b-low/b-zero/b-in/b-out/b-tr/b-dc`; tinta do movimento via `--ink` (`t-in/t-out/t-tr/t-dc`). Fonte `Cartaz` (Playfair, base64 no `@font-face`) só em títulos; resto Bahnschrift. Entrada de página só via `entrar()` em `route()`.

## Navegação, abas e rotas
- **Ir direto para:** seção `navegação`: `NAV`, `navCount()`, `VIEWS`, `route()`, `render()`, `pageHead()`.
- **Cuidados:** aba nova = entrada em `NAV` e `VIEWS` (+ ícone em `ICONS`). Parâmetros de rota ficam em `ui.query` só durante o `render()`. Abas de patrimônio em `ABAS` e `TAB_CATS` (seção `constantes`).

## Modelo de dados e persistência
- **Ir direto para:** seções `persistência` (`loadDb`, `persist`, `commit`) e `domínio` (`db`, `ui`, `patIdent`, `patDesc`, `stockState`, `catsDaAba`, `validatePatNum`, `patHistory`, `prodHistory`).
- **Formato de `db`:** `{versao, criado, config:{protoNext,lastBackup}, unidades:[{nome,setores}], categorias, produtos:[{id,tipo:'item'|'toner',nome,modelo,cor,un,min,qtd}], pats:[{id,cat,marca,modelo,posse,num,sp,locadora,un,setor,status:'ativo'|'descartado',obs,conferir,fotos?:[fotoId]}], protocolos:[{id,num,tipo,data,un,setor,pessoa,origem,obs,criado,itens:[...]}]}`. Itens de protocolo: `k:'p'` (produto, `qtd`) ou `k:'b'` (bem, `de:{un,setor,status}` para desfazer).
- **Fotos** (seção `fotos`): fora de `db`, em chaves `foto:<id>` (JPEG 1280 px em data URL); `fotoGet`, `fotoPut`, `fotoReduzir`, `fotosGc` (apaga órfãs no início, ao remover, restaurar e resetar). No backup vão em `fotos:{id:dataURL}`.
- **Cuidados:** não há migração (`versao: 1`); se mudar o formato, crie uma e aplique em `loadDb` e `restoreFile()`.

## Dados iniciais (planilha → app)
- **Ir direto para:** `tools/extrair-planilha.ps1` (`.xlsx` → `src/seed.json` bruto; `-Relatorio` lista inconsistências) e a seção `dados iniciais`: `SEED_*`, `MARCAS`/`fixMarca`, `fixModelo`, `buildInitialDb()` (normaliza, marca `conferir`, resolve duplicados e descartados).
- **Cuidados:** seed só vale para banco vazio ou "Restaurar dados da planilha". Correção de dado vai em `buildInitialDb`, não no script (só ASCII, depende do layout: linha 1 = unidades, linha 2 = campos). Não leia o `.xlsx`.

## Painel
- **Ir direto para:** seção `PAINEL` (`viewPainel`); tabela "Equipamentos por local" usa `PAINEL_EQ` (seção `constantes`) e `table.t.eq`. Só o painel usa `.g-2`.

## Lançar movimentação
- **Leia antes `docs/context/MOVIMENTOS.md`** (regras por tipo, funções, eventos, desfazer, cerimônias do registro).
- **Ir direto para:** seções `LANÇAR` (`viewLancar`, `setTipo`, `allowedInDraft`, `candidates`/`showCands`/`afterLancar`, `novoPatModal`, `registrar`) e `LANÇAR POR TEXTO` (`txtLinha`, `txtProcessar`, `simular`, `txtPreview`, `txtRegistrar`). Trocar de modo: `lanc-modo` → `trocarFolha(dir, trocar)` (trava em `ui.trocando`).
- **Máquina de escrever:** base em `maqBase(sum, botoes)`; animação na seção `máquina de escrever` (`tecla`, chamada por `datilografa` só dentro de `.folha`; `retorno`, `trava`, `arrancarFolha`, `alimentar`; carro em `ui.carro` → `--carro`). Som: `SOM` (fatias [fonte, início, duração, ganho]; refaça se trocar um MP3), `somPronto` (decodifica os base64 em idle), `som`/`somTecla`; mudo em `ui.mudo` (`almox-som` no localStorage).
- **Cuidados:** regra nova de movimento muda junto `allowedInDraft`, `registrar` e `undoProto`. Tipos em `TIPOS`, origens em `ORIGENS`.

## Movimentações, desfazer e recibo
- **Ir direto para:** seções `MOVIMENTAÇÕES` (`viewMovs`, `movTable`, `undoProto`) e `impressão` (`printProto`, CSS `@media print`).

## Patrimônios (abas por categoria) e Descarte
- **Ir direto para:** seção `PATRIMÔNIOS`: `viewPats(aba)`, `patFiltered`, `patTable`, `impressoraResumo`, `patForm`/`readPatForm`, `patDrawer`, `patSave`, `patNewModal`/`patCreate`; lote na seção `cadastro em lote` (`loteRow`, `loteCheck`, `lotePaste`, `patLoteCreate`). Marca passa por `marcaDb`. Descarte na seção `DESCARTE`.
- **Gaveta de papel** (seção `folha do patrimônio`): `folhaRig`/`desdobrar` (abre), `FOLHA_SAI` (dobra/amassa/puxa), `carimbar(dr, texto, tinta)`. Ações rápidas são `pat-ir` → `patIr` (carimbo e saída em `PAT_IR`, depois `#/lancar?tipo=…&b=…`).
- **Fotos na gaveta:** `fotosHtml`, `refreshFotos`, `patFotoAdd(files, origem)`, `prender` (WAAPI), arrastar e soltar por `dragover`/`drop` no `document` (`temArquivo`, `alvoFoto`, `marcaRecebe`; não use `.solta`, que é peça da máquina), `fotoVer`, `fotoRm`. Salvam na hora.
- **Cuidados:** número sempre por `validatePatNum`. Filtros em `ui.pf[aba]` (`pf()`).

## Itens e toners
- **Ir direto para:** seções `ITENS` (`viewItens`, `itensTable`, `prodModal`, `prodSave`, `refreshItens`) e `TONERS` (`viewToners`, `TONER_CORES`).
- **Seleção múltipla:** ids em `ui.itSel` (sobrevivem à busca), `selBox`, `itensBar`, `itAcao`; `it-lancar` vai para `#/lancar?tipo=…&p=id&p=id`.

## Busca global
- **Ir direto para:** seção `busca global` (`globalResults`, `showGlobal`); atalhos `/` e Ctrl+K na seção `eventos`. Toda busca usa `hit()` e `norm()` (seção `utilitários`).

## Documentos (modelos → PDF)
- **Ir direto para:** `MODELOS_DOC` (seção `constantes`) e seção `DOCUMENTOS`. Estado em `ui.doc = {id, etapa:'form'|'rev', v, manual}` (nulo = catálogo), nunca em `db`. `viewDocumentos` (catálogo) → `docForm` (campos + prévia) → `docRevisao` (folha + valores). `docCampo` gera o controle por `tipo`; `docSet` grava e reaplica os `auto` (editado vira `manual`; se o automático de outro campo muda, ele volta a segui-lo; setor fora da unidade é limpo); `docSync` atualiza os outros campos e só a prévia `#doc-prev`. Busca de patrimônio: `docPatCands`/`docPatBusca`. `docValida` barra Revisar e PDF. `docPdf` põe `docFolha` em `#print`, marca `html.doc-imprimindo` (página nomeada `doc`: A4, margens 20/18 mm, fundo branco) e chama `print()`.
- **Folha:** `.doc-folha` com tokens `--doc-*`; na tela tudo em `em` com fonte escalada por `cqw` (`.doc-prev` é container), então a prévia quebra linhas como a impressão. Classes para o corpo: `doc-cab`, `doc-pre`, `doc-assin` (não parte entre páginas), `doc-branco` (linha em branco).
- **Como adicionar um modelo:** 1) acrescente `{id, titulo, descricao, campos, corpo(v)}` em `MODELOS_DOC`; 2) campo = `{id, rotulo, tipo, obrigatorio?, auto?, opcoes?, dica?, de?}`, com `tipo` `texto`, `area`, `data` (ISO), `unidade`, `setor` (exige `de` = id do campo unidade), `pat` (valor = id; outros campos leem com `auto: (db, v) => docPat(db, v.<campo>)?.marca`) ou `escolha` (`opcoes`); `auto(db, v)` dá o valor inicial, sempre sobrescrevível; 3) `corpo(v)` devolve o HTML com `esc()`/`docEsc()` em todo valor e `docData()` para data por extenso. O modelo `exemplo` é provisório.

## Configurações e backup
- **Ir direto para:** seção `CONFIGURAÇÕES`: `viewConfig`, `backup` (async, inclui fotos), `restoreFile` (aceita backup sem fotos); `pats-zerar` e `reset` em `ACTIONS`.

## Build e mapa de arquivos
- `build.ps1` troca `__SEED__` (JSON compactado, `</` escapado) e `__SOM__`/`__SOM_PAPEL__`/`__SOM_FOLHA__`/`__SOM_FOGO__` pelos MP3 em base64 → `Almoxarifado TI.html` (gerado, não editar nem ler).
- `src/app.html` (fonte), `src/seed.json` (dados da planilha), `src/som-*.mp3` (máquina, papel, folha, fogo; usos em `SOM`), `tools/extrair-planilha.ps1`, `Controle de almoxarifado TI SASC.xlsx` (só leitura), `docs/context/`.
