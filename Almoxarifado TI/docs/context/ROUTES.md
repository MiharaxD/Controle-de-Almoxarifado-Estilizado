# Rotas diretas por tipo de tarefa

Quase tudo está em `src/app.html` (~1.500 linhas: CSS no `<style>`, depois JS). **Arquivo grande: não leia inteiro.**
Ache a seção pelo marcador `/* ---------- NOME ---------- */` (grep `"/\* ---------- "` lista todas) e leia só ela.
Validação: não há testes automatizados. Rode `& ".\build.ps1"`, sirva por `http://localhost` e confira no navegador (claro, escuro e largura de celular).

Fluxo geral: `init()` → `loadDb()` (IndexedDB; se vazio, `buildInitialDb()` a partir do seed) → `route()` lê o hash `#/aba?params` → `render()` chama `VIEWS[aba]()` que devolve HTML → cliques em `[data-act]` vão para `ACTIONS`, campos `[data-in]`/`[data-ch]` para `INPUTS` → alterações em `db` terminam em `commit()` (salva + redesenha o menu).

## Design, tema e layout
- **Ir direto para:** `DESIGN.md` (sistema visual) e o `<style>` de `src/app.html`: tokens num único `:root` (só escuro), keyframes e `prefers-reduced-motion` antes dos `@media (max-width…)` no fim do CSS. Ícones SVG inline em `const ICONS`; emblema e skyline (máscara SVG em `--skyline`) no próprio HTML/CSS.
- **Modais e gaveta:** seção `toasts, modal, drawer` (`openLayer`, `modal`, `closeLayer`, `confirmDialog`). `closeLayer` move o conteúdo para um `.layer-out` (sem ids, `inert`) que anima a saída e se remove em 240 ms; `openLayer` sobre um layer aberto marca `#layer.swap` para não repetir a entrada. `modal(..., { selo })` põe o carimbo animado (usado em `modalRegistrados`). Clicar fora ou Esc passa por `layerFora`: só fecha se nada foi digitado (`ui.layerSujo`, marcado por `marcaSujo` nos eventos globais); senão destaca o modal e avisa. Quem reabre o modal no lugar (ex.: `pat-modo`) deve preservar `ui.layerSujo`.
- **Cuidados:** cor nova = token novo em `:root`. Badges de status são carimbos (`b-ok/b-low/b-zero/b-in/b-out/b-tr/b-dc`, máscara `--ink-mask`). Tipo de movimento dá `--ink` via `t-in/t-out/t-tr/t-dc`. Fontes: títulos em `--display` = `Cartaz` (Playfair Display OFL, woff2 em base64 no `@font-face` do topo do `<style>`, subconjunto latino); UI e números em Bahnschrift / Bahnschrift Condensed (Windows). Entrada de página só via `entrar()` em `route()`.

## Navegação, abas e rotas
- **Ir direto para:** seção `navegação`: `NAV` (menu lateral), `navCount()`, `VIEWS` (rota → função), `route()`, `render()`, `pageHead()`.
- **Cuidados:** aba nova exige entrada em `NAV` e em `VIEWS`. Parâmetros de rota ficam em `ui.query` só durante o `render()` (são zerados depois). Abas de patrimônio são configuradas em `ABAS` e `TAB_CATS` (seção `constantes`).

## Modelo de dados e persistência
- **Ir direto para:** seções `persistência` (`loadDb`, `persist`, `commit`) e `domínio` (`db`, `ui`, helpers `patIdent`, `stockState`, `catsDaAba`, `validatePatNum`, `patHistory`, `prodHistory`).
- **Formato de `db`:** `{versao, criado, config:{protoNext,lastBackup}, unidades:[{nome,setores}], categorias, produtos:[{id,tipo:'item'|'toner',nome,modelo,cor,un,min,qtd}], pats:[{id,cat,marca,modelo,posse,num,sp,locadora,un,setor,status:'ativo'|'descartado',obs,conferir,fotos?:[fotoId]}], protocolos:[{id,num,tipo,data,un,setor,pessoa,origem,obs,criado,itens:[...]}]}`.
- **Fotos:** ficam fora de `db`, cada uma numa chave `foto:<id>` do mesmo store (JPEG reduzido para 1280 px, em data URL). Seção `fotos`: `idbReq`, `fotoGet` (com cache), `fotoPut`, `fotosGc` (apaga chaves sem patrimônio; roda no início, ao remover foto, ao restaurar e ao resetar), `fotoReduzir`. No backup elas vão num campo `fotos:{id:dataURL}` que não existe dentro de `db`.
- **Cuidados:** não existe migração de versão (`versao: 1`); se mudar o formato, crie uma e aplique também em `restoreFile()`. Itens de protocolo: `k:'p'` (produto com `qtd`) ou `k:'b'` (bem, com `de:{un,setor,status}` para desfazer).

## Dados iniciais (planilha → app)
- **Ir direto para:** `tools/extrair-planilha.ps1` (lê o `.xlsx` e grava `src/seed.json` com dados brutos; leitura de colunas por bloco de unidade, `UnitName` unifica ESTOQUE/SEMASC; `-Relatorio` lista inconsistências), `src/seed.json`, `build.ps1`, e na seção `dados iniciais`: `SEED_UNITS`, `SEED_CATS`, `SEED_ITENS`, `SEED_TONERS`, `MARCAS`/`fixMarca`, `fixModelo`, `buildInitialDb()` (normaliza, marca `conferir`, resolve duplicados e descartados).
- **Cuidados:** o seed só vale para banco vazio ou "Restaurar dados da planilha" em Configurações. Correção de dado vai em `buildInitialDb` (app), não no script, que só extrai. O script depende do layout da planilha (linha 1 = unidades, linha 2 = campos) e deve ficar só em ASCII.
- **Não precisa ler:** o `.xlsx` (binário; já está em `seed.json`).

## Painel
- **Ir direto para:** seção `PAINEL` (`viewPainel`: banners, atalhos `.quick`, KPIs `.g-kpi`, colunas `.g-2`). Tabela "Equipamentos por local" usa `PAINEL_EQ` (seção `constantes`: rótulo, categorias e aba de destino de cada coluna) e o CSS `table.t.eq`.
- **Cuidados:** só o painel usa `.g-2`; as colunas internas têm `minmax(0, 1fr)` para tabela larga não estourar a tela no celular.

## Lançar movimentação (entrada, saída, transferência, descarte)
- **Mapa detalhado (regras por tipo, funções, eventos, desfazer, recibo): `docs/context/MOVIMENTOS.md`. Leia antes de mexer.**
- **Ir direto para:** seção `LANÇAR`: `newDraft`, `viewLancar`, `draftItemRow`, `setTipo`, `allowedInDraft` (regras por tipo), `addItem`, `candidates`/`showCands`/`afterLancar` (busca e Enter), `novoPatModal`/`novoPatSave`, `registrar()` (`validarDraft` + `gravarDraft`). Modo "Por texto" na seção `LANÇAR POR TEXTO` (`txtLinha`, `txtProcessar`, `simular`, `txtPreview`, `txtRegistrar`).
- **Cuidados:** regra nova de movimento muda junto `allowedInDraft`, `registrar` e `undoProto`. Tipos e rótulos em `TIPOS`; origens de entrada em `ORIGENS`.

## Movimentações, desfazer e recibo
- **Ir direto para:** seções `MOVIMENTAÇÕES` (`viewMovs`, `movTable`, `undoProto`) e `impressão` (`printProto`, CSS `@media print`).

## Patrimônios (Todos, CPU, Monitor, Impressora, Estabilizador, Outros) e Descarte
- **Ir direto para:** seção `PATRIMÔNIOS`: `viewPats(aba)`, `patFiltered`, `patChips`, `patTable`, `impressoraResumo`, `patForm`/`readPatForm`, `patDrawer` (detalhe, fotos, histórico, ações rápidas), `patSave`, `patNewModal`/`patCreate` (modal com "Um patrimônio" ou "Vários de uma vez"; o lote fica na seção `cadastro em lote`: `loteRow` com nº, marca opcional e nº da locadora, `loteCheck`, `lotePaste`/`loteColado`, `patLoteCreate`). Marca digitada passa por `marcaDb` (reaproveita a grafia já cadastrada). Fotos na gaveta: `fotosHtml`, `refreshFotos`, `patFotoAdd`, `fotoVer` (ampliação `.lightbox` dentro de `#layer`), `fotoRm` (remoção em dois cliques). Elas são salvas na hora, sem passar pelo "Salvar alterações". Descarte em seção `DESCARTE`.
- **Cuidados:** validação de número sempre por `validatePatNum`. Filtros de cada aba em `ui.pf[aba]` (`pf()`).

## Itens e toners
- **Ir direto para:** seções `ITENS` (`viewItens`, `itensTable`, `prodModal`, `prodSave`) e `TONERS` (`viewToners`, cores em `TONER_CORES`).

## Busca global
- **Ir direto para:** seção `busca global` (`globalResults`, `showGlobal`); atalhos `/` e Ctrl+K na seção `eventos`. Toda busca usa `hit()` (palavras em qualquer ordem) e `norm()` (sem acento) da seção `utilitários`.

## Configurações e backup
- **Ir direto para:** seção `CONFIGURAÇÕES`: `viewConfig`, `backup` (async, inclui fotos), `restoreFile` (grava as fotos do backup e aceita backup sem fotos). Card "Recomeçar": `pats-zerar` (apaga só os patrimônios e fotos; protocolos guardam rótulo e nº, então o histórico continua legível) e `reset` (volta ao seed) em `ACTIONS`.

## Build e entrega
- **Ir direto para:** `build.ps1` (troca `__SEED__` em `<script id="seed">` pelo JSON compactado e escapa `</`).
- **Não precisa ler:** `Almoxarifado TI.html` (gerado; tem o seed embutido).

## Mapa arquivo → papel
- `src/app.html` — fonte do app inteiro (CSS + JS + placeholder `__SEED__`).
- `src/seed.json` — dados brutos da planilha usados no primeiro uso.
- `build.ps1` — gera o entregável.
- `tools/extrair-planilha.ps1` — planilha → `src/seed.json`.
- `Almoxarifado TI.html` — entregável gerado (não editar).
- `Controle de almoxarifado TI SASC.xlsx` — planilha original (somente leitura).
- `docs/context/` — estes documentos de contexto.
