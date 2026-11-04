# Movimentos: Entrada, Saída, Transferência, Descarte

Mapa para achar e alterar o fluxo sem reler `src/app.html`. Ache por nome de função (grep `function nome`), não por número de linha.

## Modelo
- **Rascunho** `ui.draft` = `{tipo,data,un,setor,pessoa,origem,obs,itens}` (`newDraft`). Itens do rascunho: `{k:'p',id,qtd}` produto; `{k:'b',id}` patrimônio existente; `{k:'n',pat}` patrimônio novo (só em Entrada).
- **Protocolo** gravado em `db.protocolos` por `registrar()`: itens `{k:'p',id,qtd,label}` ou `{k:'b',id,label,ident,de:{un,setor,status},novo}`. `de` guarda o estado anterior (usado por `undoProto` e pela coluna "Local anterior"). Numeração: `db.config.protoNext`.
- **Constantes** (seção `constantes`): `TIPOS` (rótulo, ícone, classes `t-*`/`b-*`, dica), `ORIGENS` (origens de Entrada), `ESTOQUE` (= unidade `Estoque TI`).

## Regras por tipo
| Tipo | Patrimônio (`b`) aceito | Produto (`p`) | Efeito ao registrar | Campos |
|---|---|---|---|---|
| Entrada | ativo e fora do `ESTOQUE` (devolver) ou novo (`n`) | sim, soma `qtd` | pat vai para `ESTOQUE`, setor vazio; `n` é criado em `db.pats` | origem; unidade/setor só se origem = "Devolução de unidade"; "Entregue por" |
| Saída | ativo e no `ESTOQUE` | sim, `qtd` ≤ estoque | pat vai para `d.un`/`d.setor`; subtrai `qtd` | unidade destino obrigatória; "Recebido por" |
| Transferência | ativo e fora do `ESTOQUE` | **não** | pat vai para `d.un`/`d.setor` | unidade destino obrigatória |
| Descarte | ativo, qualquer local | sim, `qtd` ≤ estoque | pat vira `status:'descartado'` (local não muda); subtrai `qtd` | sem unidade nem pessoa; `obs` = "Motivo do descarte" |

Regra única de elegibilidade: `allowedInDraft(k,obj,tipo?)` (tipo padrão = `ui.draft.tipo`); mensagem do bloqueio em `motivoBloqueio(p,tipo)`. `validarDraft(d)` repete as validações (destino, data, qtd inteira ≥ 1, estoque suficiente, `validatePatNum` nos novos, elegibilidade de cada `b`). Em Entrada que não é devolução e em Descarte, `pr.un`/`pr.setor` ficam vazios.

## Onde está cada coisa (`src/app.html`)
- **Tela Lançar** (seção `LANÇAR`): `viewLancar` (lê `?tipo=&origem=&p=&b=` e limpa a URL), `draftSummary`, `draftItemRow`, `setTipo` (descarta itens que não valem no novo tipo), `allowedInDraft`, `addItem`, `candidates` (busca, ordena por score, máx. 10) → `showCands` → `afterLancar` (foco, setas, Enter), `renderLancarKeepFocus`, `novoPatModal`/`novoPatSave` (patrimônio novo; "Salvar e adicionar outro"), `registrar` (= `validarDraft` → `gravarDraft` (aplica no `db` e devolve o protocolo, sem salvar) → `commit` → `modalRegistrados(prs)`).
- **Lançar por texto** (seção `LANÇAR POR TEXTO`; botão "Por texto" no topo de Lançar, modo em `ui.lancModo` + `almox-lanc-modo` no localStorage, texto em `ui.txt`): `txtLinha(src,locs)` interpreta uma linha contra o `db` atual (tipo pela 1ª palavra em `TXT_TIPOS`; data `hoje`/`ontem`/`dd/mm`; `por` = pessoa; `obs`/`motivo` = obs; `para` separa origem e destino; unidade e setor por `txtCasa` (romano = arábico, prefixo só se único); nº de 5–6 dígitos = patrimônio, categoria por `txtCat`/`TXT_CATS`; demais palavras = produto por `txtProdutos` com quantidade). `txtProcessar` junta linhas seguidas com a mesma chave (tipo, data, local, origem, pessoa, obs) num rascunho e grava cada grupo com `validarDraft`/`gravarDraft`; a prévia (`txtPreview`) roda isso dentro de `simular()` (cópia rasa do `db`), e `txtRegistrar` roda de novo no `db` real só se a prévia não tiver erros. Ctrl+Enter via `data-ctrl-enter`.
- **Histórico** (seção `MOVIMENTAÇÕES`): `viewMovs` (filtros `ui.mf`, `?p=nº` abre o protocolo), `movTable` (linha expansível via `mov-toggle`; botão Desfazer só no protocolo mais recente), `undoProto`.
- **Descarte** (seção `DESCARTE`): `viewDescarte` lista `db.pats` com `status==='descartado'` (protocolo via `patHistory`; sem protocolo = veio da "Planilha") e uma segunda tabela com itens de estoque descartados (protocolos de descarte, `k:'p'`).
- **Recibo** (seção `impressão`): `printProto`; duas vias ("Via da TI" + "Via da unidade") só em Saída e Transferência; rótulos "Entregue por"/"Recebido por" e "Motivo" no descarte. CSS em `@media print`.
- **Auxiliares** (seção `domínio`): `protoDest(pr)` (texto de origem/destino: origem da Entrada, "Baixa do inventário" no Descarte), `tipoBadge`, `patHistory`, `prodHistory`, `loc(un,setor)`, `validatePatNum`.
- **Eventos**: `ACTIONS` → `tipo`, `rm-item`, `draft-clear`, `novo-pat`, `edit-novo`, `novo-pat-save`, `cand`, `registrar`, `lanc-modo`, `txt-ex`, `txt-limpar`, `txt-registrar`, `print`, `undo`, `mov-toggle`. `INPUTS` → `txt` (prévia com atraso de 150 ms), `draft` (zera `setor` ao trocar `un`; limpa `un`/`setor` se origem ≠ devolução), `qty` (atualiza "Em estoque: a → b" e erro de excesso sem redesenhar).
- **Entradas para o fluxo** (links `#/lancar?tipo=…`): Painel (aviso de estoque zerado → Entrada com origem "Ajuste de inventário"), Itens e Toners (botões Entrada/Saída por produto, `&p=id`), Patrimônios (botão Saída; na gaveta `patDrawer`: Saída, Devolver ao estoque, Transferir, Descartar, `&b=id`), Descarte (Novo descarte). Estado "descartado" também aparece em `patTable`, `patDrawer`, filtro `ui.pf[aba].status` e busca global.

## Cuidados ao alterar
- Regra nova de movimento: mexer junto em `allowedInDraft`, `validarDraft`/`gravarDraft`, `txtLinha` (checagens por linha), `undoProto`, `candidates`, `draftItemRow`/`INPUTS.qty` (texto "Em estoque") e `DECISIONS.md`.
- `undoProto` só serve o último protocolo: reverte `qtd` (entrada soma, demais subtraem), restaura `de` nos patrimônios (inclusive `status`), remove os `novo`, e recua `protoNext`. Campo novo em `de` ou no protocolo precisa ser revertido ali.
- Formato do protocolo é lido de backups antigos: não renomeie campos; só acrescente com valor padrão.
- Seed/carga: patrimônios descartados da planilha nascem em `buildInitialDb` (seção `dados iniciais`), sem protocolo.
