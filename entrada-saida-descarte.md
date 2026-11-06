# Entrada / Saída / Descarte — documentos e código

## docs/context/ROUTES.md (trechos)
```
## Lançar movimentação (entrada, saída, transferência, descarte)
- **Ir direto para:** seção `LANÇAR`: `newDraft`, `viewLancar`, `draftItemRow`, `setTipo`, `allowedInDraft` (regras por tipo), `addItem`, `candidates`/`showCands`/`afterLancar` (busca e Enter), `novoPatModal`/`novoPatSave`, `registrar()` (valida e aplica).
- **Cuidados:** regra nova de movimento muda junto `allowedInDraft`, `registrar` e `undoProto`. Tipos e rótulos em `TIPOS`; origens de entrada em `ORIGENS`.

## Movimentações, desfazer e recibo
- **Ir direto para:** seções `MOVIMENTAÇÕES` (`viewMovs`, `movTable`, `undoProto`) e `impressão` (`printProto`, CSS `@media print`).

## Patrimônios (Todos, CPU, Monitor, Impressora, Estabilizador, Outros) e Descarte
- **Ir direto para:** seção `PATRIMÔNIOS`: `viewPats(aba)`, `patFiltered`, `patChips`, `patTable`, `impressoraResumo`, `patForm`/`readPatForm`, `patDrawer` (detalhe, fotos, histórico, ações rápidas), `patSave`, `patNewModal`/`patCreate`. Fotos na gaveta: `fotosHtml`, `refreshFotos`, `patFotoAdd`, `fotoVer` (ampliação `.lightbox` dentro de `#layer`), `fotoRm` (remoção em dois cliques). Elas são salvas na hora, sem passar pelo "Salvar alterações". Descarte em seção `DESCARTE`.
```

## docs/context/DECISIONS.md
```
# Decisões ativas

- **Arquivo HTML único e offline, em 1 PC, sem login.** Por quê: uso local pela TI, sem servidor. Proíbe: dependências externas (CDN, fontes web), backend, autenticação.
- **Persistência no IndexedDB com fallback para localStorage; backup manual em `.json`.** Por quê: único armazenamento durável sem servidor. Exige: manter backups antigos restauráveis.
- **Fotos de patrimônio (até 8 por bem) ficam fora de `db`, em chaves `foto:<id>`, reduzidas para JPEG de 1280 px.** Por quê: `db` é regravado inteiro a cada alteração e precisa continuar leve. Exige: incluir as fotos no backup e limpar as órfãs (`fotosGc`). No fallback para localStorage não há fotos.
- **Patrimônio aceita 5 ou 6 dígitos, mantém zeros à esquerda e não aceita duplicados.** Por quê: a planilha tem números dos dois tamanhos. Exige: validar sempre por `validatePatNum`.
- **Têm patrimônio:** CPU, notebook, monitor, impressora, projetor, roteador, estabilizador, TV, relógio de ponto, caixa de som (e o que estiver em `categorias`). Demais itens são controlados só por quantidade.
- **S.P. (sem patrimônio) é permitido, e o nº da locadora é um campo separado.** Por quê: impressoras locadas e bens sem etiqueta. Proíbe: guardar nº de locadora no campo `num`.
- **Estoque e movimentações começam zerados; patrimônios vêm da planilha.** Por quê: pedido do usuário para começar do zero com os mesmos itens.
- **Local = unidade + setor opcional.** O estoque da TI é a unidade `Estoque TI`. SEMASC foi unificada como SASC.
- **Um protocolo agrupa vários itens, numerado automaticamente** (próximo número editável em Configurações). Responsável = nome de quem recebeu.
- **Tipos de movimento: Entrada, Saída, Transferência, Descarte.** Entrada põe itens e patrimônios no `Estoque TI` (só ela cadastra patrimônio novo); Saída leva do `Estoque TI` para uma unidade; Transferência só move patrimônio que já está fora do `Estoque TI`; Descarte dá baixa definitiva. Regras em `allowedInDraft`.
- **Desfazer só o protocolo mais recente.** Por quê: desfazer fora de ordem quebraria estoque e localização. Proíbe: desfazer protocolos antigos.
- **Toners por modelo + cor, com histórico de consumo por unidade.**
- **Recibo impresso: duas vias em Saída e Transferência.**
- **Visual "Inventory & Stock Management" (ui-ux-pro-max):** flat, neutros slate, acento verde, status semáforo, tabelas densas, tema claro/escuro automático com troca manual.
- **Correções de dados feitas na carga:** "Concordla" → "Concórdia", modelos de impressora padronizados, duplicados mantêm o registro de protocolo mais recente, patrimônio que aparece no Descarte vira descartado; todos esses ficam marcados "Conferir".
```

## src/app.html linhas 397-403 (constantes-TIPOS-ORIGENS)
```js
const TIPOS = {
  entrada: { label: 'Entrada', icon: 'in', cls: 't-in', badge: 'b-in', hint: 'Item chega ao estoque da TI' },
  saida: { label: 'Saída', icon: 'out', cls: 't-out', badge: 'b-out', hint: 'Entrega do estoque para uma unidade' },
  transferencia: { label: 'Transferência', icon: 'transfer', cls: 't-tr', badge: 'b-tr', hint: 'Patrimônio muda de unidade/setor' },
  descarte: { label: 'Descarte', icon: 'trash', cls: 't-dc', badge: 'b-dc', hint: 'Baixa definitiva do inventário' },
};
const ORIGENS = ['Compra / fornecedor', 'Devolução de unidade', 'Retorno de manutenção', 'Doação', 'Ajuste de inventário', 'Outro'];
```

## src/app.html linhas 683-688 (dominio-protoDest)
```js
function protoDest(pr) {
  if (pr.tipo === 'entrada') return pr.origem + (pr.un ? ` (${loc(pr.un, pr.setor)})` : '');
  if (pr.tipo === 'descarte') return 'Baixa do inventário';
  return loc(pr.un, pr.setor);
}

```

## src/app.html linhas 1130-1353 (LANCAR)
```js
/* ---------- LANÇAR ---------- */
function newDraft(tipo) { return { tipo, data: today(), un: '', setor: '', pessoa: '', origem: ORIGENS[0], obs: '', itens: [] }; }
function viewLancar() {
  const q = ui.query;
  if (!ui.draft) ui.draft = newDraft('saida');
  if (q.has('tipo') && TIPOS[q.get('tipo')]) setTipo(q.get('tipo'), true);
  if (q.has('origem')) ui.draft.origem = q.get('origem');
  if (q.has('p')) addItem('p', q.get('p'), true);
  if (q.has('b')) addItem('b', q.get('b'), true);
  if ([...q.keys()].length) history.replaceState(null, '', '#/lancar');
  ui.query = new URLSearchParams();
  const d = ui.draft, T = TIPOS[d.tipo];
  const needDest = d.tipo === 'saida' || d.tipo === 'transferencia';
  const destUnits = unitNames().filter(u => u !== ESTOQUE);
  return pageHead('Lançar movimentação', 'Um protocolo pode ter vários itens. O estoque e o local dos patrimônios são atualizados ao registrar.') +
    `<div class="seg lg" role="group" aria-label="Tipo de movimentação" style="margin-bottom:16px">${Object.entries(TIPOS).map(([k, t]) => `<button class="${t.cls}" data-act="tipo" data-tipo="${k}" aria-pressed="${d.tipo === k}">${icon(t.icon)}${t.label}</button>`).join('')}</div>
    <div class="lanc">
      <section class="card"><header><span class="ico ${T.cls}" style="width:32px;height:32px;border-radius:8px;display:grid;place-items:center">${icon(T.icon)}</span><h2>Protocolo Nº ${db.config.protoNext}</h2></header>
        <div class="body form-stack">
          <label class="f">Data<input class="input" type="date" value="${d.data}" data-in="draft" data-k="data" max="${today()}"></label>
          ${d.tipo === 'entrada' ? `<label class="f">Origem<select class="input" data-ch="draft" data-k="origem" data-rerender="1">${ORIGENS.map(o => `<option ${d.origem === o ? 'selected' : ''}>${o}</option>`).join('')}</select></label>` : ''}
          ${needDest || (d.tipo === 'entrada' && d.origem === 'Devolução de unidade') ? `
            <div class="row2">
              <label class="f">${needDest ? 'Unidade de destino *' : 'Unidade de origem'}<select class="input" id="d-un" data-ch="draft" data-k="un" data-rerender="1"><option value="">Selecione</option>${destUnits.map(u => `<option ${d.un === u ? 'selected' : ''}>${esc(u)}</option>`).join('')}</select></label>
              <label class="f">Setor<select class="input" data-ch="draft" data-k="setor" ${d.un && setoresDe(d.un).length ? '' : 'disabled'}>${setorOpts(d.un, d.setor)}</select></label>
            </div>` : ''}
          ${d.tipo !== 'descarte' ? `<label class="f">${d.tipo === 'entrada' ? 'Entregue por' : 'Recebido por'}<span class="hint">Nome da pessoa</span><input class="input" value="${esc(d.pessoa)}" data-in="draft" data-k="pessoa" autocomplete="off" list="dl-pessoas"></label>` : ''}
          <datalist id="dl-pessoas">${[...new Set(db.protocolos.map(p => p.pessoa).filter(Boolean))].slice(-200).map(n => `<option>${esc(n)}</option>`).join('')}</datalist>
          <label class="f">${d.tipo === 'descarte' ? 'Motivo do descarte' : 'Observação'}<span class="hint">Chamado, defeito, nota fiscal…</span><textarea class="input" rows="3" data-in="draft" data-k="obs">${esc(d.obs)}</textarea></label>
        </div>
      </section>
      <section class="card">
        <header><h2>Itens do protocolo</h2><span class="badge b-neutral" style="margin-left:auto">${plural(d.itens.length, 'item', 'itens')}</span></header>
        <div class="adder">
          <div class="search">${icon('search')}<label class="sr" for="add-q">Adicionar item</label><input id="add-q" class="input" type="search" autocomplete="off" placeholder="${d.tipo === 'transferencia' ? 'Digite o nº do patrimônio ou marca' : 'Digite o nº do patrimônio, item ou toner'}" aria-controls="cands" aria-autocomplete="list"></div>
          <div class="hint"><span><kbd>Enter</kbd> adiciona o primeiro resultado · leitor de código de barras funciona aqui</span>${d.tipo === 'entrada' ? `<button class="btn sm" data-act="novo-pat" style="margin-left:auto">${icon('plus')}Novo patrimônio</button>` : ''}</div>
          <div class="cands" id="cands" role="listbox" hidden></div>
        </div>
        ${d.itens.length ? `<ul class="list itens">${d.itens.map((it, i) => draftItemRow(it, i)).join('')}</ul>` : `<div class="empty"><b>Nenhum item adicionado</b>${esc(T.hint)}. Busque acima para adicionar itens, toners ou patrimônios.</div>`}
        <div class="lanc-foot">
          <span class="sum">${draftSummary()}</span>
          ${d.itens.length ? `<button class="btn ghost" data-act="draft-clear">Limpar</button>` : ''}
          <button class="btn primary" data-act="registrar" ${d.itens.length ? '' : 'disabled'}>${icon('check')}Registrar ${T.label.toLowerCase()}</button>
        </div>
        <p class="err-msg" id="lanc-err" role="alert" style="padding:0 16px 12px;margin:0"></p>
      </section>
    </div>`;
}
function draftSummary() {
  const it = ui.draft.itens;
  const q = it.filter(i => i.k === 'p').reduce((s, i) => s + (i.qtd || 0), 0);
  const b = it.filter(i => i.k !== 'p').length;
  return [q ? plural(q, 'unidade') + ' de estoque' : '', b ? plural(b, 'patrimônio') : ''].filter(Boolean).join(' · ') || 'Adicione pelo menos um item';
}
function draftItemRow(it, i) {
  const d = ui.draft;
  if (it.k === 'p') {
    const p = prodById(it.id); if (!p) return '';
    const over = (d.tipo === 'saida' || d.tipo === 'descarte') && it.qtd > p.qtd;
    return `<li><span class="ico" style="width:32px;height:32px;border-radius:8px;display:grid;place-items:center;background:var(--surface-2);color:var(--text-2)">${icon(p.tipo === 'toner' ? 'toner' : 'box')}</span>
      <span class="grow"><b>${esc(prodLabel(p))}</b><span class="sub">Em estoque: ${p.qtd}${d.tipo === 'entrada' ? ` → ${p.qtd + (it.qtd || 0)}` : d.tipo !== 'transferencia' ? ` → ${p.qtd - (it.qtd || 0)}` : ''}</span>${over ? `<span class="err-msg">Quantidade maior que o estoque</span>` : ''}</span>
      <label class="sr" for="q${i}">Quantidade</label><input id="q${i}" class="input qty ${over ? 'err' : ''}" type="number" min="1" step="1" value="${it.qtd}" data-in="qty" data-i="${i}">
      <button class="btn icon sm ghost" data-act="rm-item" data-i="${i}" aria-label="Remover ${esc(prodLabel(p))}">${icon('x')}</button></li>`;
  }
  const p = it.k === 'n' ? it.pat : patById(it.id); if (!p) return '';
  const dest = d.tipo === 'entrada' ? ESTOQUE : d.tipo === 'descarte' ? 'Descarte' : (d.un ? loc(d.un, d.setor) : 'destino');
  return `<li><span class="ico" style="width:32px;height:32px;border-radius:8px;display:grid;place-items:center;background:var(--surface-2);color:var(--text-2)">${icon(abaDaCat(p.cat) === 'outros' ? 'tag' : { cpu: 'cpu', monitor: 'monitor', impressora: 'printer', estabilizador: 'zap' }[abaDaCat(p.cat)])}</span>
    <span class="grow">${patIdentHtml(p)} <b>${esc(patDesc(p))}</b>${it.k === 'n' ? ' <span class="badge b-in">Novo</span>' : ''}<span class="sub">${it.k === 'n' ? 'Cadastro novo' : esc(loc(p.un, p.setor))} → ${esc(dest)}</span></span>
    ${it.k === 'n' ? `<button class="btn icon sm ghost" data-act="edit-novo" data-i="${i}" aria-label="Editar novo patrimônio">${icon('edit')}</button>` : ''}
    <button class="btn icon sm ghost" data-act="rm-item" data-i="${i}" aria-label="Remover patrimônio">${icon('x')}</button></li>`;
}
function setTipo(t, silent) {
  const d = ui.draft; if (d.tipo === t) return;
  d.tipo = t;
  const before = d.itens.length;
  d.itens = d.itens.filter(it => allowedInDraft(it.k, it.k === 'p' ? prodById(it.id) : it.k === 'b' ? patById(it.id) : it.pat));
  if (t === 'entrada') { d.un = d.origem === 'Devolução de unidade' ? d.un : ''; d.setor = d.origem === 'Devolução de unidade' ? d.setor : ''; }
  if (!silent && d.itens.length < before) toast(`${before - d.itens.length} item(ns) removido(s): não se aplicam a ${TIPOS[t].label.toLowerCase()}.`);
}
function allowedInDraft(k, obj) {
  const t = ui.draft.tipo;
  if (!obj) return false;
  if (k === 'n') return t === 'entrada';
  if (k === 'p') return t !== 'transferencia';
  if (obj.status !== 'ativo') return false;
  if (t === 'entrada') return obj.un !== ESTOQUE;
  if (t === 'saida') return obj.un === ESTOQUE;
  if (t === 'transferencia') return obj.un !== ESTOQUE;
  return true;
}
function addItem(k, id, silent) {
  const d = ui.draft;
  const obj = k === 'p' ? prodById(id) : patById(id);
  if (!obj) return;
  if (!allowedInDraft(k, obj)) {
    if (!silent || k === 'b') toast(k === 'b' ? `${patIdent(obj)}: ${obj.status !== 'ativo' ? 'patrimônio descartado' : d.tipo === 'saida' ? 'não está no estoque da TI (use Transferência)' : d.tipo === 'entrada' ? 'já está no estoque da TI' : 'não pode ser transferido do estoque (use Saída)'}.` : 'Item não se aplica a este tipo.', true);
    return;
  }
  const ex = d.itens.find(i => i.k === k && i.id === id);
  if (ex) { if (k === 'p') ex.qtd++; else if (!silent) toast('Patrimônio já está na lista.'); return; }
  d.itens.push(k === 'p' ? { k, id, qtd: 1 } : { k, id });
}
function candidates(q) {
  const d = ui.draft, nq = norm(q), out = [];
  const inDraft = new Set(d.itens.filter(i => i.k === 'b').map(i => i.id));
  for (const p of db.pats) {
    if (inDraft.has(p.id) || !allowedInDraft('b', p)) continue;
    if (!nq) continue;
    const hay = norm([p.num, p.locadora, p.cat, p.marca, p.modelo, p.un, p.setor].join(' '));
    if (!hit(hay, nq)) continue;
    const exact = p.num === q.trim() || p.locadora === q.trim();
    out.push({ k: 'b', id: p.id, score: exact ? 0 : (p.num || '').startsWith(q.trim()) ? 1 : 3, html: `${patIdentHtml(p)} <span>${esc(patDesc(p))}</span>`, sub: esc(loc(p.un, p.setor)) });
  }
  if (d.tipo !== 'transferencia') for (const p of db.produtos) {
    if ((d.tipo === 'saida' || d.tipo === 'descarte') && p.qtd <= 0) continue;
    if (nq && !hit(norm(prodLabel(p) + ' ' + p.tipo), nq)) continue;
    out.push({ k: 'p', id: p.id, score: 2, html: `${icon(p.tipo === 'toner' ? 'toner' : 'box')}<span>${esc(prodLabel(p))}</span>`, sub: `Estoque: ${p.qtd}` });
  }
  return out.sort((a, b) => a.score - b.score).slice(0, 10);
}
function showCands() {
  const inp = $('#add-q'), box = $('#cands');
  if (!inp || !box) return;
  const q = inp.value;
  const list = candidates(q);
  ui.cands = list; ui.candSel = 0;
  if (!list.length) {
    box.hidden = !q.trim();
    const n = q.trim();
    box.innerHTML = `<div class="empty" style="padding:16px">${PAT_RE.test(n) && ui.draft.tipo === 'entrada' && !db.pats.some(p => p.num === n) ? `Patrimônio ${esc(n)} não cadastrado. <button class="btn sm" data-act="novo-pat" data-num="${esc(n)}">${icon('plus')}Cadastrar como novo</button>` : 'Nenhum resultado disponível para este tipo de movimentação.'}</div>`;
    return;
  }
  box.hidden = false;
  box.innerHTML = list.map((c, i) => `<button role="option" class="${i === 0 ? 'sel' : ''}" data-act="cand" data-k="${c.k}" data-id="${c.id}">${c.html}<span class="sub">${c.sub}</span></button>`).join('');
}
function afterLancar() {
  const inp = $('#add-q'); if (!inp) return;
  inp.addEventListener('focus', showCands);
  inp.addEventListener('input', showCands);
  inp.addEventListener('keydown', e => {
    const box = $('#cands'), n = ui.cands ? ui.cands.length : 0;
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      if (!n) return; e.preventDefault();
      ui.candSel = (ui.candSel + (e.key === 'ArrowDown' ? 1 : -1) + n) % n;
      $$('button[role=option]', box).forEach((b, i) => b.classList.toggle('sel', i === ui.candSel));
    } else if (e.key === 'Enter') {
      e.preventDefault();
      const c = ui.cands && ui.cands[ui.candSel];
      if (c) { addItem(c.k, c.id); renderLancarKeepFocus(); }
      else { const nb = $('#cands [data-act="novo-pat"]'); if (nb) nb.click(); }
    } else if (e.key === 'Escape') { box.hidden = true; }
  });
}
function hideCandsOutside(e) { const a = $('.adder'); if (a && !a.contains(e.target)) { const b = $('#cands'); if (b) b.hidden = true; } }
function renderLancarKeepFocus() {
  render();
  const inp = $('#add-q'); if (inp) { inp.focus(); }
}
function novoPatModal(idx, num) {
  const it = idx != null ? ui.draft.itens[idx] : null;
  const p = it ? it.pat : { cat: 'CPU', posse: '', marca: '', modelo: '', num: num || '', sp: false, locadora: '', obs: '' };
  ui.novoIdx = idx;
  modal(it ? 'Editar novo patrimônio' : 'Novo patrimônio na entrada', `<p style="margin:0;color:var(--text-2);font-size:14px">O bem será cadastrado no <b>${ESTOQUE}</b> ao registrar o protocolo.</p>${patForm(p)}`,
    `<button class="btn" data-act="close-layer">Cancelar</button>${it ? '' : `<button class="btn" data-act="novo-pat-save" data-more="1">Salvar e adicionar outro</button>`}<button class="btn primary" data-act="novo-pat-save">${icon('check')}${it ? 'Salvar' : 'Adicionar'}</button>`);
  if (num) setTimeout(() => $('#pt-marca') && $('#pt-marca').focus());
}
function novoPatSave(more) {
  const others = ui.draft.itens.filter((it, i) => it.k === 'n' && i !== ui.novoIdx && it.pat.num).map(it => it.pat.num);
  const r = readPatForm(null, others);
  if (r.err) return showFormErr(r);
  if (ui.novoIdx != null) ui.draft.itens[ui.novoIdx].pat = r.data;
  else ui.draft.itens.push({ k: 'n', pat: r.data });
  if (more) {
    const keep = { ...r.data, num: '', obs: '' };
    ui.novoIdx = null;
    closeLayer(); render(); novoPatModal(null);
    Object.entries({ '#pt-cat': keep.cat, '#pt-posse': keep.posse, '#pt-marca': keep.marca, '#pt-modelo': keep.modelo }).forEach(([s, v]) => { $(s).value = v; });
    $('#pt-num').focus();
    toast('Adicionado. Informe o próximo.');
  } else { closeLayer(); renderLancarKeepFocus(); }
}
function registrar() {
  const d = ui.draft, err = m => { $('#lanc-err').textContent = m; toast(m, true); };
  if (!d.itens.length) return err('Adicione pelo menos um item.');
  if ((d.tipo === 'saida' || d.tipo === 'transferencia') && !d.un) { $('#d-un') && $('#d-un').focus(); return err('Selecione a unidade de destino.'); }
  if (!d.data) return err('Informe a data.');
  for (const it of d.itens) {
    if (it.k !== 'p') continue;
    const p = prodById(it.id);
    if (!Number.isInteger(it.qtd) || it.qtd < 1) return err(`Quantidade inválida para ${prodLabel(p)}.`);
    if ((d.tipo === 'saida' || d.tipo === 'descarte') && it.qtd > p.qtd) return err(`${prodLabel(p)}: estoque insuficiente (${p.qtd}).`);
  }
  for (const it of d.itens) if (it.k === 'n' && it.pat.num) { const e = validatePatNum(it.pat.num, null); if (e) return err(e); }
  for (const it of d.itens) if (it.k === 'b') { const p = patById(it.id); if (!allowedInDraft('b', p)) return err(`${patIdent(p)} não pode entrar neste protocolo (local mudou).`); }

  const pr = { id: uid(), num: db.config.protoNext, tipo: d.tipo, data: d.data, un: d.un, setor: d.setor, pessoa: d.pessoa.trim(), origem: d.tipo === 'entrada' ? d.origem : '', obs: d.obs.trim(), criado: new Date().toISOString(), itens: [] };
  if (d.tipo === 'entrada' && d.origem !== 'Devolução de unidade') { pr.un = ''; pr.setor = ''; }
  if (d.tipo === 'descarte') { pr.un = ''; pr.setor = ''; }
  for (const it of d.itens) {
    if (it.k === 'p') {
      const p = prodById(it.id);
      p.qtd += d.tipo === 'entrada' ? it.qtd : -it.qtd;
      pr.itens.push({ k: 'p', id: p.id, qtd: it.qtd, label: prodLabel(p) });
      continue;
    }
    let p;
    if (it.k === 'n') { p = { id: 'P' + uid(), ...it.pat, un: ESTOQUE, setor: '', status: 'ativo', conferir: '' }; db.pats.push(p); }
    else p = patById(it.id);
    const de = { un: p.un, setor: p.setor, status: p.status };
    if (d.tipo === 'entrada') { p.un = ESTOQUE; p.setor = ''; }
    else if (d.tipo === 'descarte') { p.status = 'descartado'; }
    else { p.un = d.un; p.setor = d.setor; }
    pr.itens.push({ k: 'b', id: p.id, label: patDesc(p), ident: patIdent(p), de, novo: it.k === 'n' });
  }
  db.protocolos.push(pr);
  db.config.protoNext++;
  commit();
  ui.draft = newDraft(d.tipo);
  render();
  ui.lastProto = pr.id;
  modal(`Protocolo Nº ${pr.num} registrado`, `<p style="margin:0">${tipoBadge(pr.tipo)} ${plural(pr.itens.length, 'item', 'itens')} · ${esc(protoDest(pr))}</p><p style="margin:0;color:var(--text-2)">Estoque e locais já foram atualizados.</p>`,
    `<a class="btn" href="#/movimentacoes?p=${pr.num}">Ver protocolo</a><button class="btn" data-act="close-layer">Novo lançamento</button><button class="btn primary" data-act="print" data-id="${pr.id}" autofocus>${icon('print')}Imprimir comprovante</button>`);
}

```

## src/app.html linhas 1354-1404 (MOVIMENTACOES-undoProto)
```js
/* ---------- MOVIMENTAÇÕES ---------- */
function viewMovs() {
  const f = ui.mf;
  if (ui.query.has('p')) { f.q = ui.query.get('p'); ui.open = { [f.q]: true }; }
  return pageHead('Movimentações', 'Histórico de protocolos de entrada, saída, transferência e descarte.', `<a class="btn primary" href="#/lancar">${icon('plus')}Lançar</a>`) +
    `<section class="card"><div class="toolbar">
      <div class="search">${icon('search')}<label class="sr" for="mq">Buscar</label><input id="mq" class="input" type="search" placeholder="Nº protocolo, patrimônio, pessoa, item" value="${esc(f.q)}" data-in="mf" data-k="q"></div>
      <label class="sr" for="mt">Tipo</label><select id="mt" class="input" data-ch="mf" data-k="tipo"><option value="">Todos os tipos</option>${Object.entries(TIPOS).map(([k, t]) => `<option value="${k}" ${f.tipo === k ? 'selected' : ''}>${t.label}</option>`).join('')}</select>
      <label class="sr" for="mu">Unidade</label><select id="mu" class="input" data-ch="mf" data-k="un"><option value="">Todas as unidades</option>${unitNames().filter(u => u !== ESTOQUE).map(u => `<option ${f.un === u ? 'selected' : ''}>${esc(u)}</option>`).join('')}</select>
      <label class="f" style="flex-direction:row;align-items:center;gap:6px">De<input class="input" type="date" value="${f.de}" data-ch="mf" data-k="de"></label>
      <label class="f" style="flex-direction:row;align-items:center;gap:6px">Até<input class="input" type="date" value="${f.ate}" data-ch="mf" data-k="ate"></label>
      <span class="count" id="mcount"></span>
    </div><div class="tbl-wrap" id="mtable">${movTable()}</div></section>`;
}
function movTable() {
  const f = ui.mf, q = norm(f.q);
  const rows = db.protocolos.filter(pr =>
    (!f.tipo || pr.tipo === f.tipo) && (!f.un || pr.un === f.un) && (!f.de || pr.data >= f.de) && (!f.ate || pr.data <= f.ate) &&
    (!q || String(pr.num) === q || hit(norm([pr.pessoa, pr.obs, pr.origem, pr.un, pr.setor, ...pr.itens.map(i => (i.ident || '') + ' ' + i.label)].join(' ')), q))
  ).sort((a, b) => b.num - a.num);
  const latest = db.protocolos.reduce((m, p) => (!m || p.num > m.num ? p : m), null);
  setTimeout(() => { const c = $('#mcount'); if (c) c.textContent = plural(rows.length, 'protocolo'); });
  if (!rows.length) return `<div class="empty"><b>${db.protocolos.length ? 'Nenhum protocolo encontrado' : 'Nenhum protocolo registrado'}</b>${db.protocolos.length ? 'Ajuste os filtros.' : 'Use "Lançar" para registrar a primeira movimentação.'}</div>`;
  return `<table class="t"><thead><tr><th class="n">Nº</th><th>Data</th><th>Tipo</th><th>Origem / destino</th><th>Pessoa</th><th>Itens</th><th class="n">Ações</th></tr></thead><tbody>
    ${rows.map(pr => {
      const open = ui.open[pr.num];
      return `<tr class="click" data-act="mov-toggle" data-num="${pr.num}" aria-expanded="${!!open}"><td class="n"><b>${pr.num}</b></td><td>${fmtD(pr.data)}</td><td>${tipoBadge(pr.tipo)}</td><td>${esc(protoDest(pr))}</td><td>${esc(pr.pessoa) || '<span style="color:var(--text-3)">—</span>'}</td>
        <td class="muted">${esc(pr.itens.slice(0, 2).map(i => (i.k === 'p' ? i.qtd + '× ' : (i.ident || '') + ' ') + i.label).join('; '))}${pr.itens.length > 2 ? ` +${pr.itens.length - 2}` : ''}</td>
        <td class="n" style="white-space:nowrap"><button class="btn sm ghost" data-act="print" data-id="${pr.id}" aria-label="Imprimir protocolo ${pr.num}">${icon('print')}</button>${latest && latest.id === pr.id ? `<button class="btn sm ghost" data-act="undo" data-id="${pr.id}" aria-label="Desfazer protocolo ${pr.num}" title="Desfazer (só o último protocolo)">${icon('undo')}</button>` : ''}</td></tr>
        ${open ? `<tr><td colspan="7" style="background:var(--surface-2)"><div style="display:grid;gap:8px;padding:4px 0">
          ${pr.obs ? `<div><b>${pr.tipo === 'descarte' ? 'Motivo' : 'Observação'}:</b> ${esc(pr.obs)}</div>` : ''}
          <table class="t" style="background:var(--surface);border:1px solid var(--border);border-radius:6px"><thead><tr><th class="n">Qtd</th><th>Item</th><th>Patrimônio</th><th>Local anterior</th></tr></thead><tbody>
          ${pr.itens.map(i => `<tr ${i.k === 'b' ? `class="click" data-act="pat-open" data-id="${i.id}"` : ''}><td class="n">${i.k === 'p' ? i.qtd : 1}</td><td>${esc(i.label)}${i.novo ? ' <span class="badge b-in">Novo</span>' : ''}</td><td>${i.k === 'b' ? `<span class="pat">${esc(i.ident)}</span>` : '—'}</td><td class="muted">${i.k === 'b' && !i.novo ? esc(loc(i.de.un, i.de.setor)) : '—'}</td></tr>`).join('')}
          </tbody></table></div></td></tr>` : ''}`;
    }).join('')}
  </tbody></table>`;
}
function undoProto(id) {
  const pr = db.protocolos.find(p => p.id === id);
  confirmDialog(`Desfazer protocolo Nº ${pr.num}?`, 'O estoque e os locais dos patrimônios voltam ao que eram antes. Patrimônios cadastrados neste protocolo serão removidos.', 'Desfazer', () => {
    for (const it of pr.itens) {
      if (it.k === 'p') { const p = prodById(it.id); if (p) p.qtd -= pr.tipo === 'entrada' ? it.qtd : -it.qtd; continue; }
      if (it.novo) { db.pats = db.pats.filter(p => p.id !== it.id); continue; }
      const p = patById(it.id); if (p) Object.assign(p, it.de);
    }
    db.protocolos = db.protocolos.filter(p => p.id !== id);
    if (db.config.protoNext === pr.num + 1) db.config.protoNext = pr.num;
    commit(); closeLayer(); render(); toast(`Protocolo Nº ${pr.num} desfeito.`);
  }, true);
}

```

## src/app.html linhas 1405-1418 (DESCARTE)
```js
/* ---------- DESCARTE ---------- */
function viewDescarte() {
  const q = norm(ui.df.q);
  const rows = db.pats.filter(p => p.status === 'descartado' && (!q || hit(norm([p.num, p.cat, p.marca, p.modelo, p.obs].join(' ')), q)));
  const when = p => { const h = patHistory(p.id).find(pr => pr.tipo === 'descarte'); return h ? h : null; };
  const prodDesc = db.protocolos.filter(pr => pr.tipo === 'descarte').flatMap(pr => pr.itens.filter(i => i.k === 'p').map(i => ({ pr, i })));
  return pageHead('Descarte', 'Bens baixados do inventário.', `<a class="btn danger" href="#/lancar?tipo=descarte">${icon('trash')}Novo descarte</a>`) +
    `<section class="card"><div class="toolbar"><div class="search">${icon('search')}<label class="sr" for="dq">Buscar</label><input id="dq" class="input" type="search" placeholder="Nº, categoria, detalhes" value="${esc(ui.df.q)}" data-in="df" data-k="q"></div><span class="count">${plural(rows.length, 'patrimônio')}</span></div>
    <div class="tbl-wrap">${rows.length ? `<table class="t"><thead><tr><th>Patrimônio</th><th>Categoria</th><th>Marca / detalhes</th><th>Protocolo</th><th>Último local</th></tr></thead><tbody>
      ${rows.map(p => { const h = when(p); return `<tr class="click" data-act="pat-open" data-id="${p.id}"><td>${patIdentHtml(p)}</td><td>${esc(p.cat)}</td><td>${esc([p.marca, p.modelo].filter(Boolean).join(' · '))}${p.obs ? ` <span style="color:var(--text-3)">${esc(p.obs)}</span>` : ''}</td><td>${h ? `Nº ${h.num} · ${fmtD(h.data)}` : '<span style="color:var(--text-3)">Planilha</span>'}</td><td class="muted">${esc(p.un ? loc(p.un, p.setor) : '—')}</td></tr>`; }).join('')}
    </tbody></table>` : `<div class="empty"><b>Nenhum patrimônio descartado</b></div>`}</div></section>` +
    (prodDesc.length ? `<section class="card" style="margin-top:16px"><header><h2>Itens de estoque descartados</h2></header><div class="tbl-wrap"><table class="t"><thead><tr><th>Protocolo</th><th>Data</th><th>Item</th><th class="n">Qtd</th><th>Motivo</th></tr></thead><tbody>${prodDesc.map(({ pr, i }) => `<tr><td>Nº ${pr.num}</td><td>${fmtD(pr.data)}</td><td>${esc(i.label)}</td><td class="n">${i.qtd}</td><td class="muted">${esc(pr.obs)}</td></tr>`).join('')}</tbody></table></div></section>` : '');
}

```

## src/app.html linhas 1482-1497 (impressao)
```js
/* ---------- impressão ---------- */
function printProto(id) {
  const pr = db.protocolos.find(p => p.id === id); if (!pr) return;
  const via = n => `<div class="via"><h1>Comprovante de ${esc(TIPOS[pr.tipo].label.toLowerCase())} · Protocolo Nº ${pr.num}</h1>
    <div>Almoxarifado TI · SASC · ${n}</div>
    <div class="meta"><div><b>Data:</b> ${fmtD(pr.data)}</div><div><b>Tipo:</b> ${esc(TIPOS[pr.tipo].label)}</div>
      <div><b>${pr.tipo === 'entrada' ? 'Origem' : 'Destino'}:</b> ${esc(protoDest(pr))}</div><div><b>${pr.tipo === 'entrada' ? 'Entregue por' : 'Recebido por'}:</b> ${esc(pr.pessoa) || '____________________'}</div></div>
    <table><thead><tr><th style="width:50pt">Qtd</th><th>Descrição</th><th style="width:110pt">Patrimônio</th></tr></thead><tbody>
      ${pr.itens.map(i => `<tr><td>${i.k === 'p' ? i.qtd : 1}</td><td>${esc(i.label)}</td><td>${i.k === 'b' ? esc(i.ident) : '—'}</td></tr>`).join('')}
    </tbody></table>
    ${pr.obs ? `<div><b>${pr.tipo === 'descarte' ? 'Motivo' : 'Observação'}:</b> ${esc(pr.obs)}</div>` : ''}
    <div class="sign"><div>Responsável TI</div><div>${pr.tipo === 'entrada' ? 'Entregue por' : 'Recebido por'}${pr.pessoa ? ': ' + esc(pr.pessoa) : ''}</div></div></div>`;
  $('#print').innerHTML = via('Via da TI') + (pr.tipo === 'saida' || pr.tipo === 'transferencia' ? via('Via da unidade') : '');
  window.print();
}

```

## src/app.html linhas 1555-1564 e 1580-1593 (ACTIONS/INPUTS de lançamento)
```js
  tipo: t => { setTipo(t.dataset.tipo); render(); },
  cand: t => { addItem(t.dataset.k, t.dataset.id); renderLancarKeepFocus(); },
  'rm-item': t => { ui.draft.itens.splice(+t.dataset.i, 1); render(); },
  'draft-clear': () => { ui.draft.itens = []; render(); },
  'novo-pat': t => novoPatModal(null, t.dataset.num),
  'edit-novo': t => novoPatModal(+t.dataset.i),
  'novo-pat-save': t => novoPatSave(!!t.dataset.more),
  registrar,
  print: t => printProto(t.dataset.id),
  undo: t => undoProto(t.dataset.id),
  draft: t => {
    const k = t.dataset.k; ui.draft[k] = t.value;
    if (k === 'un') ui.draft.setor = '';
    if (k === 'origem' && t.value !== 'Devolução de unidade') { ui.draft.un = ''; ui.draft.setor = ''; }
    if (t.dataset.rerender || k === 'un') render();
  },
  qty: t => {
    const it = ui.draft.itens[+t.dataset.i]; it.qtd = parseInt(t.value, 10) || 0;
    const li = t.closest('li'), p = prodById(it.id), d = ui.draft;
    const over = (d.tipo === 'saida' || d.tipo === 'descarte') && it.qtd > p.qtd;
    t.classList.toggle('err', over);
    $('.sub', li).textContent = `Em estoque: ${p.qtd}${d.tipo === 'entrada' ? ` → ${p.qtd + it.qtd}` : ` → ${p.qtd - it.qtd}`}`;
    let em = $('.err-msg', li); if (over && !em) { em = document.createElement('span'); em.className = 'err-msg'; em.textContent = 'Quantidade maior que o estoque'; $('.grow', li).append(em); } else if (!over && em) em.remove();
    $('.lanc-foot .sum').textContent = draftSummary();
```
