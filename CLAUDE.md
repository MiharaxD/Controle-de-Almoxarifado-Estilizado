# Almoxarifado TI (SASC)

Controle de estoque, toners e patrimônios da TI da SASC. App web offline de arquivo único
(HTML + CSS + JS puro, sem framework, sem dependências, sem servidor), usado em 1 PC.
Os dados iniciais vieram da planilha `Controle de almoxarifado TI SASC.xlsx`.

## Comandos
- Gerar o entregável (Windows PowerShell 5.1): `& ".\build.ps1"` → junta `src/app.html` + `src/seed.json` + `src/som-maquina.mp3` + `src/som-papel.mp3` + `src/som-folha.mp3` + `src/som-fogo.mp3` + `src/brasao.png` (em base64) em `index.html`.
- Regerar o seed a partir da planilha: `& ".\tools\extrair-planilha.ps1" [-Planilha arq.xlsx] [-Relatorio]` → sobrescreve `src/seed.json`; depois rode o build.
- Rodar: abrir `index.html` no navegador (duplo clique). Não há instalação nem testes automatizados.
- Testar no navegador com armazenamento: servir por `http://localhost` (em `file://` ou data: URL o comportamento de storage muda). Use um HttpListener simples na porta 8765; teste por lá para não sujar os dados reais do usuário.
- Não há Python nesta máquina; scripts auxiliares são PowerShell.

## Invariantes
- Sempre edite `src/app.html`, nunca `index.html` (é gerado e sobrescrito pelo build).
- O entregável continua sendo um único `.html` offline: nada de CDN, fontes externas ou arquivos ao lado.
- Os dados do usuário ficam no IndexedDB do navegador (`almoxarifado-ti` / store `kv` / chave `db`; fotos em chaves `foto:<id>`, que também vão no backup). Mudança no formato de `db` precisa continuar abrindo dados e backups `.json` antigos.
- Patrimônio: 5 ou 6 dígitos (`PAT_RE`), mantém zeros à esquerda, sem duplicados entre ativos. S.P. (sem patrimônio) é permitido; nº da locadora é campo separado.
- Estoque nunca fica negativo; só o protocolo mais recente pode ser desfeito.
- Arquivos lidos/gravados pelo build: UTF-8 sem BOM (o PS 5.1 lê sem BOM como ANSI; evite acentos em literais de scripts `.ps1`).

## Estilo
- JS em português nos nomes de domínio (`pats`, `protocolos`, `viewPainel`), funções curtas, HTML montado com template strings e `esc()`.
- Eventos só por delegação: `data-act` (clique → `ACTIONS`), `data-in`/`data-ch` (→ `INPUTS`). Não adicione listeners soltos por elemento.
- Cores só por tokens CSS em `:root` (só tema escuro). Comentários raros, de seção (`/* ---------- X ---------- */`).
- Identidade visual: `DESIGN.md` (Art Déco noturno inspirado no dossiê Deadlock). Animação de conteúdo só na troca de aba (`.view.entering`), nunca em CSS de algo que `render()` redesenha; feedback de ação (máquina de escrever do Lançar) é WAAPI disparado pela própria ação.
- Textos da interface e mensagens em português do Brasil.

## Protocolo de consulta (antes de qualquer tarefa)
1. Leia `docs/context/ROUTES.md` e vá direto aos caminhos do tipo de tarefa.
2. Leia `docs/context/STATE.md` e `docs/context/DECISIONS.md` só se a tarefa depender de estado, prioridades ou escolhas de produto.
3. Explore além disso só se a rota não cobrir o caso. `src/app.html` é grande: use grep e leia trechos.

## Protocolo de manutenção (ao terminar trabalho relevante, sem precisar pedir)
- Atualize só os documentos afetados, antes de declarar a tarefa concluída.
- Substitua em vez de acrescentar: remova o que ficou obsoleto, as pendências concluídas e as redundâncias.
- Se descobriu um caminho novo ou uma rota errada, corrija o `ROUTES.md`.
- Nunca registre diário, log de sessão, raciocínio, SHAs, resultados de teste datados ou tamanhos de build.
- Respeite os limites de tamanho (CLAUDE.md ~80 linhas; cada doc de contexto ~2.000 tokens); quando chegar perto, compacte.
- Instruções novas do usuário prevalecem; atualize os documentos quando elas mudarem uma regra.
