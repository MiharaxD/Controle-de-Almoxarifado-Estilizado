---
name: Almoxarifado TI
description: Controle de estoque, toners e patrimônios da TI da SASC como um cartaz Art Déco noturno, carimbado.
colors:
  night-petrol: "#0A1113"
  night-petrol-2: "#0E181B"
  surface: "#121D20"
  surface-2: "#182629"
  surface-3: "#213337"
  well: "#0C1517"
  border: "#253A3E"
  border-strong: "#375155"
  cream: "#F0E7D3"
  cream-2: "#C7BEA8"
  cream-3: "#979282"
  sage: "#94B9A4"
  gaslamp: "#74E3A4"
  gaslamp-fg: "#03160C"
  ice: "#9AD6F2"
  amber: "#F3AE48"
  stamp-red: "#F2746C"
  danger-ink: "#A8261F"
  tower-violet: "#C3A8F5"
  overlay: "rgba(3, 8, 9, .74)"
  paper: "#EADFC4"
  paper-2: "#DACBA8"
  paper-stain: "#8E6A35"
  paper-ink: "#1D1A15"
  paper-print: "#2C4A46"
  brass: "#C99A4B"
  chrome: "#B9B3A2"
  folder: "#D3B987"
  folder-2: "#BC9E66"
  folder-inside: "#957646"
  graphite: "#3A3C41"
typography:
  display:
    fontFamily: "Cartaz, \"Sitka Banner\", \"Sitka Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "clamp(28px, 3.6vw, 46px)"
    fontWeight: 600
    lineHeight: 1
    letterSpacing: ".03em"
  headline:
    fontFamily: "Cartaz, \"Sitka Banner\", \"Sitka Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "24px"
    fontWeight: 600
    lineHeight: 1.05
    letterSpacing: ".02em"
  numeral:
    fontFamily: "\"Bahnschrift Condensed\", Bahnschrift, \"Arial Narrow\", sans-serif"
    fontSize: "46px"
    fontWeight: 600
    lineHeight: 1
    letterSpacing: ".01em"
    fontFeature: "\"lnum\", \"tnum\""
  title:
    fontFamily: "\"Bahnschrift Condensed\", Bahnschrift, \"Arial Narrow\", sans-serif"
    fontSize: "15px"
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: ".14em"
  body:
    fontFamily: "Bahnschrift, \"Segoe UI\", system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "\"Bahnschrift Condensed\", Bahnschrift, \"Arial Narrow\", sans-serif"
    fontSize: "12px"
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: ".12em"
  mono:
    fontFamily: "\"Cascadia Mono\", Consolas, \"SFMono-Regular\", Menlo, monospace"
    fontSize: "13px"
    fontWeight: 600
    letterSpacing: ".02em"
rounded:
  sm: "2px"
  md: "3px"
spacing:
  xs: "6px"
  sm: "10px"
  md: "14px"
  lg: "18px"
  xl: "28px"
components:
  button:
    backgroundColor: "{colors.surface-3}"
    textColor: "{colors.cream}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "0 15px"
    height: "38px"
  button-hover:
    textColor: "{colors.gaslamp}"
  button-primary:
    backgroundColor: "{colors.gaslamp}"
    textColor: "{colors.gaslamp-fg}"
    rounded: "{rounded.sm}"
    padding: "0 15px"
    height: "38px"
  button-danger:
    backgroundColor: "{colors.surface-2}"
    textColor: "{colors.stamp-red}"
    rounded: "{rounded.sm}"
  input:
    backgroundColor: "{colors.well}"
    textColor: "{colors.cream}"
    typography: "{typography.body}"
    rounded: "{rounded.sm}"
    padding: "0 11px"
    height: "38px"
  chip:
    backgroundColor: "{colors.surface-2}"
    textColor: "{colors.cream-2}"
    rounded: "{rounded.sm}"
    padding: "0 11px"
    height: "30px"
  chip-selected:
    backgroundColor: "{colors.gaslamp}"
    textColor: "{colors.gaslamp-fg}"
  badge-stamp:
    textColor: "{colors.gaslamp}"
    rounded: "{rounded.sm}"
    padding: "0 8px"
    height: "22px"
  card:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.md}"
    padding: "16px"
  nav-item:
    textColor: "{colors.cream-2}"
    rounded: "{rounded.sm}"
    padding: "0 10px"
    height: "38px"
  nav-item-active:
    textColor: "{colors.gaslamp}"
---

# Design System: Almoxarifado TI

## Overview

**Creative North Star: "O Cartaz Carimbado da Cidade Noturna"**

O almoxarifado é um cartaz Art Déco impresso à noite, inspirado no dossiê de Deadlock fornecido pelo usuário: noite azul-petróleo quase preta, um céu com brilho verde "gaslamp" no canto superior direito, meio-tom de pontos e grão de papel por cima de tudo. O texto é creme, como tinta clara sobre papel escuro. Cada protocolo é carimbado e cada status é um carimbo de tinta torto. A imersão é total e o tema é só escuro; não existe variante clara. A única superfície clara é um objeto do mundo: a folha de papel envelhecido do protocolo, presa numa máquina de escrever.

O mundo vive na casca (menu lateral com emblema de bússola e skyline Déco ao pé, molduras de filete duplo, cantos marcados em verde, losangos), nos carimbos e nos títulos-cartaz. A operação continua densa e rápida: tabelas, formulários e listas ficam onde o usuário espera, e nenhum efeito atrasa digitar e registrar. O movimento é curto (120 a 350 ms), físico e de papel: cartas que pousam, gavetas que deslizam, menus que desdobram, carimbos que batem.

O sistema recusa o painel SaaS cinza com um acento verde: o verde aqui é luz de lampião, raro e luminoso, e a cor de status é tinta, não pílula.

**Key Characteristics:**
- Só tema escuro, noite azul-petróleo com céu verde e meio-tom de pontos.
- Títulos em serifa de cartaz caixa alta com sobreimpressão vermelha.
- Rótulos, navegação, botões e números grandes em grotesca condensada caixa alta espaçada.
- Status como carimbos tortos com tinta falhada; selo do tipo ("RECEBIDO", "ENTREGUE", "TRANSFERIDO", "DESCARTADO") no fim do protocolo.
- Molduras Art Déco de filete duplo, cantos verdes e losangos como marcadores.
- Brilho gaslamp reservado a ação, foco, estado ativo e medidores.
- Cartas levemente giradas que se endireitam ao passar o mouse.

## Colors

Uma noite fria de azul-petróleo com tinta creme, luz verde de lampião e quatro tintas de status que nomeiam os tipos de movimento.

### Primary
- **Verde Gaslamp** (gaslamp): a luz e a "magia" do mundo. Botão principal, item ativo da navegação, foco, cursor de texto, medidores, seleção, chip selecionado, marcadores em losango e o brilho do céu. Também é a tinta de Entrada (`--ink` de `.t-in`) e do status "ok". Sobre ele, o texto é **Verde-Breu** (gaslamp-fg).

### Secondary
- **Âmbar de Alerta** (amber): estoque baixo, KPI de atenção, banners de aviso, medidor baixo, contorno de "nudge". Também aquece o canto inferior esquerdo do fundo, bem fraco.
- **Vermelho-Carimbo** (stamp-red): perigo, zerado, descarte, erro de campo, botão destrutivo.
- **Tinta Vermelha Escura** (danger-ink): a sobreimpressão desalinhada dos títulos-cartaz e o fundo do toast de erro. Não é cor de texto.

### Tertiary
- **Azul-Gelo** (ice): Saída e banners informativos.
- **Roxo de Torre** (tower-violet): Transferência.

Cada cor de status tem par `-soft` (10% de alfa, fundo) e `-line` (cerca de 38 a 40%, contorno) em `:root`; use os pares, nunca alfas novos inventados.

### Papel do protocolo
A folha (`.papel`) é papel envelhecido: creme (paper → paper-2), ou verde-claro no modo Por texto (`.papel.verde`) com fibra e manchas em ruído SVG, vinheta de bordas e um anel de café discreto. Dentro dela os tokens são redefinidos: texto vira tinta de fita (paper-ink), rótulos são impressos em petróleo escuro (paper-print) e as tintas de movimento escurecem (`--papel-verde`, `--papel-azul`, `--papel-roxo`, danger-ink) para ler sobre o creme. Carimbos e selo usam `mix-blend-mode: multiply`. Metal da máquina: cromo (chrome) e latão (brass), com breu (`--breu`) nas sombras.

### Neutral
- **Noite Petróleo** (night-petrol / night-petrol-2): fundo da página e base inferior dos gradientes de cartão e do menu lateral.
- **Superfícies** (surface, surface-2, surface-3): cartões, cabeçalhos de cartão e tabela, botões e toasts, do mais fundo ao mais alto.
- **Poço** (well): interior de campos, segmentados e medidores; é a única superfície "afundada".
- **Filetes** (border, border-strong): contornos e o filete duplo de 3px.
- **Creme** (cream, cream-2, cream-3): texto principal, secundário e terciário/placeholder.
- **Sálvia** (sage): rótulos de campo, cabeçalhos de tabela, títulos de grupo, ícones de busca. É a voz dos rótulos, não do conteúdo.

### Named Rules
**The Lampião Rule.** O verde gaslamp com brilho (glow) aparece só em botão principal, losango do item ativo, foco, medidores e hover (sombra deslocada com desfoque). Uma superfície em repouso nunca brilha.

**The Ink-Per-Movement Rule.** Cada tipo de movimento tem uma única tinta, via `--ink`: Entrada verde, Saída azul-gelo, Transferência roxo, Descarte vermelho. A mesma tinta pinta o carimbo, o segmentado ativo, o losango do ícone e o hover do atalho.

**The Token-Only Rule.** Cores só por tokens de `:root`, misturadas com `color-mix()` quando preciso. Nenhum hex solto em componente.

## Typography

**Display Font:** Playfair Display (SIL OFL 1.1), embutida em base64 no `@font-face` com o nome `Cartaz`. É um subconjunto latino (A–Z, a–z, 0–9, acentos do português, pontuação básica), variável de 400 a 800 e usada a 600, com algarismos alinhados (`lining-nums`). Se faltar, cai para Sitka Banner, Georgia e Times New Roman. O comentário de copyright e licença fica junto do `@font-face`. Para trocar a fonte: baixe o woff2 com `&text=` na API do Google Fonts e substitua o base64.
**Body Font:** Bahnschrift (com Segoe UI, system-ui)
**Label/Mono Font:** Bahnschrift Condensed (com Bahnschrift, Arial Narrow); Cascadia Mono (com Consolas)
**Hand Font** (`--mao`): Ink Free (com Segoe Print, Segoe Script). Só para o que é escrito a lápis: descrição das pastas e valores dos campos do bloco de notas de Documentos.

**Character:** Serifa de cartaz em caixa alta contra uma grotesca industrial condensada e espaçada: o título é o cartaz, o resto é a etiqueta de inventário. A serifa vai embutida no próprio HTML e as demais são fontes do Windows, então o arquivo continua offline e sem fontes externas.

### Hierarchy
- **Display** (600, clamp(28px, 3.6vw, 46px), 1): título-cartaz de cada página, caixa alta, com sobreimpressão `2px 2px 0` em danger-ink e halo verde fraco. Entra com clip-path da esquerda ao trocar de aba.
- **Headline** (600, 24px, 1.05): títulos de modal e gaveta, caixa alta, sobreimpressão `1.5px 1.5px 0`. Variante 19–20px a 400 para a marca e para o estado vazio.
- **Numeral** (600, 46px nos KPIs, 36px nos toners, 1): números grandes em Bahnschrift Condensed com algarismos tabulares e alinhados.
- **Title** (600, 15px, 1.2, .14em, caixa alta): título de cartão, precedido de losango verde.
- **Body** (400, 15px, 1.5): texto corrido, células (14px), subtítulos de lista (13px, cream-3).
- **Label** (600, 11–13px, .08–.24em, caixa alta): rótulos de campo, cabeçalhos de tabela, grupos de navegação (.22em), botões (14px, .08em), navegação (15px, 500, .05em), subtítulo da página.
- **Mono** (600, 13px, .02em): números de patrimônio, numeração de linhas e o modo texto de lançamento (14px/1.7).

### Named Rules
**The Unambiguous Zero Rule.** Todo número que se lê como dado (KPI, quantidade, contador) vai em Bahnschrift Condensed ou Cascadia Mono, nunca na serifa de cartaz: os algarismos da Playfair têm alto contraste e não servem para ler dados.

**The Poster-Only Serif Rule.** A serifa de cartaz (`--display`) é só para títulos-cartaz (página, modal, gaveta, marca, estado vazio). Rótulos, botões e navegação nunca usam a serifa.

**The Patrimônio Rule.** Patrimônio sempre em mono com zeros à esquerda; "S.P." em Bahnschrift itálico cream-3, para ler como ausência, não como número.

## Layout

Grade de duas colunas: menu lateral fixo de 248px e área principal. A barra superior é fixa com fundo noite a 84% e blur de 10px. O conteúdo vive numa coluna de até 1440px com 28px de respiro. Cabeçalho de página: título à esquerda, ações à direita, filete inferior com segundo filete esmaecido e um losango vazado verde na ponta esquerda.

O ritmo é denso e modular: vãos de 18px entre cartões da grade, 14–16px dentro dos cartões, 10–12px entre itens de lista, 6–8px entre controles irmãos. O Painel abre com quatro atalhos em cartas, quatro KPIs e duas colunas (3fr / 2fr). Toners em grade auto-fill de 220px.

Responsivo: abaixo de 1100px as grades de quatro viram duas e as de duas viram uma; abaixo de 860px o menu lateral vira gaveta (268px, fora da tela, com véu de overlay) e o respiro cai para 18/16px; abaixo de 520px tudo vira coluna única, o rodapé do modal empilha botões em largura total e os colchetes do botão principal somem.

**The Steady Grid Rule.** O mundo inclina peças (cartas, carimbos, KPIs, toners) entre .4° e 2°, mas a grade nunca inclina. Linhas de tabela, campos e colunas ficam retos.

## Elevation & Depth

Profundidade híbrida: camadas tonais (gradiente de surface para night-petrol-2 em cada cartão) mais sombras escuras e ambientais. O fundo carrega atmosfera própria (céu verde, meio-tom de pontos 6px mascarado, grão de papel a 5%). Campos, segmentados e medidores afundam com sombra interna; cartões flutuam pouco; camadas (modal, gaveta, dropdown, toast) flutuam muito. O brilho verde é estado, nunca repouso.

### Shadow Vocabulary
- **Repouso** (`--shadow-1: 0 2px 6px rgba(0,0,0,.35)`): cartões e atalhos em repouso.
- **Camada** (`--shadow-2: 0 22px 56px rgba(0,0,0,.6), 0 3px 10px rgba(0,0,0,.45)`): modal, dropdowns, toasts, lightbox e cartas em hover.
- **Poço** (`inset 0 2px 4px rgba(0,0,0,.35)`): campos, segmentados.
- **Brilho de hover** (`0 6px 18px -8px var(--accent-glow)` e `0 10px 26px -12px var(--accent-glow)`): botões, chips, KPIs e toners em hover; sombra deslocada com desfoque, nunca contorno duro.
- **Brilho do principal** (`0 0 22px -8px var(--accent-glow)`, 28px/-4px em hover).
- **Gaveta** (`-28px 0 70px rgba(0,0,0,.55)`).

### Named Rules
**The Lit-On-Demand Rule.** Superfícies ficam apagadas em repouso. O brilho verde aparece como resposta a estado: hover, foco, ativo, ou ao próprio botão principal.

**The Misregistration Rule.** A única sombra dura (offset sem desfoque) do sistema é a sobreimpressão em danger-ink dos títulos-cartaz, que imita impressão desalinhada. Ela não se estende a caixas.

## Shapes

Cantos quase retos: 2px (`rounded.sm`) para controles e carimbos, 3px (`rounded.md`) para cartões, modais, toasts e dropdowns. Nada é pílula; só o ponto de cor é círculo.

A moldura Art Déco é a forma recorrente: cartões e modais têm um filete interno a 3px de recuo (`--frame`) e oito cantoneiras verdes de 12px nos quatro cantos (`--corner`). Divisões estruturais (cabeçalho de cartão, de tabela, de gaveta, rodapé de lançamento, marca) usam filete duplo de 3px em border-strong. Losangos (quadrado girado 45°) são o marcador universal: item ativo, título de cartão, primeira coluna de tabela, linha do tempo, fundo dos ícones. Medidores são barras de 6px com canto de 1px.

## Components

### Buttons
Etiquetas de inventário em relevo: firmes, condensadas, em caixa alta.
- **Shape:** quase reto (2px), altura 38px (32px no `.sm`, 46px no rodapé de lançamento).
- **Padrão:** gradiente surface-3 para surface-2, filete border-strong, texto creme, label 14px .08em. Hover: contorno e texto verdes com brilho deslocado. Pressionado: desce 1px e encolhe para .98 em 50ms.
- **Principal:** gradiente verde clareado para gaslamp, texto verde-breu, brilho próprio. Fora do tamanho `.sm`, ganha colchetes angulares verdes nas laterais que se afastam 3px no hover. Um por contexto.
- **Perigo:** texto e contorno vermelho-carimbo sobre superfície levemente avermelhada.
- **Fantasma:** sem fundo nem contorno; hover com fundo verde suave. Fechar (x) gira 90° no hover.

### Chips
- **Style:** surface-2, filete border, label 13px .06em caixa alta, cream-2; contagem em creme tabular.
- **State:** hover acende contorno verde; selecionado vira verde sólido com texto verde-breu. Remover (x) acende vermelho suave.

### Cards / Containers
- **Corner Style:** 3px, com moldura interna e cantoneiras verdes (ver Shapes).
- **Background:** gradiente surface para night-petrol-2.
- **Shadow Strategy:** Repouso; Camada mais brilho no hover das cartas clicáveis.
- **Border:** border; cabeçalho com filete duplo, meio-tom de 5px e título com losango.
- **Internal Padding:** 16px (cabeçalho 13px 16px).

### Inputs / Fields
- **Style:** poço (well) com filete border-strong, 2px, 38px, sombra interna; texto Bahnschrift 14px; rótulo acima em label sálvia, dica em corpo 12px cream-3. Selects com seta desenhada em sálvia.
- **Focus:** contorno verde, anel de 3px accent-soft e brilho difuso; seta do select fica verde.
- **Error / Disabled:** contorno vermelho, anel danger-soft e tremida de 300ms; desabilitado a 50%.

### Segmented Control
Poço com botões condensados; o ativo sobe para surface-3 com sublinhado interno de 2px na tinta do movimento (`--ink`). A versão grande (46px) escolhe o tipo de movimento e pinta o texto com a tinta.

### Navigation
- **Style:** menu lateral em gradiente noturno; marca com bússola verde (gira 45° no hover) e nome na serifa de cartaz (600, 17px); grupos em label sálvia .22em com filete que esmaece; itens em condensada 15px caixa alta.
- **States:** hover varre um gradiente verde suave da esquerda e empurra o ícone 2px. Ativo: texto verde, fundo verde, contorno accent-line, giro de -1° e losango verde brilhante à esquerda. Contadores tabulares à direita.
- **Mobile:** abaixo de 860px vira gaveta lateral com overlay.
- **Pé:** skyline Déco mascarada com brilho verde por baixo.

### Stamp Badges (assinatura)
Status são carimbos de tinta: condensada 700 12px caixa alta, contorno de 1.5px e fundo de 9% na própria cor, girados -2° (1.5° em linhas pares) e mascarados por `--ink-mask` (ruído fractal) para parecer tinta falhada. A cor vem da tinta do status ou do movimento. O neutro é reto, sem máscara, com filete fino.

### Máquina de escrever (Lançar, assinatura)
O protocolo é datilografado: a folha `.papel` (cabeçalho impresso "SASC · Tecnologia da Informação", título em serifa de cartaz, tipo em carimbo, nº em tinta vermelha de fita; campos sem caixa, com linha tracejada e texto em Courier New 700) entra na máquina, vista de frente e um pouco de cima. Carro: rolo de borracha com guia de papel e roletes, pontas laqueadas, botões cilíndricos serrilhados, alavanca de retorno cromada e régua creme numerada (0 a 80, margens vermelhas) que anda com o carro sob um ponteiro gaslamp fixo. Deck em petróleo laqueado com brilho: carretéis cromados elípticos com fita vermelha em trapézio até o suporte de cartão (hastes cromadas, marcas vermelhas), cesta de tipos em meia-elipse com raios (sol Art Déco) e cubo de latão, linhas de velocidade em latão nas laterais, sino. Frente (sem teclado, só a parte de cima da máquina): faixa fina com a placa de latão escalonada "Almoxarifado · TI", botão de som e resumo à esquerda e botões à direita. A base fica fixa no pé da tela, exceto em telas com até 760px de altura ou 520px de largura. A fita bicolor (preto e vermelho) marca o ponto de batida.
- **Batida de tecla** (`tecla`, WAAPI): escolha (tipo, select, data, item adicionado ou removido) sobe a fita, o martelo bate, os carretéis giram a fita, o corpo tranca 1,5px e o carro (folha + rolo) anda 2px para a esquerda (1px no celular, até 10 passos; no 10º o sino toca). O valor escolhido aparece letra a letra (clip-path em `steps(14)`, 280ms). Digitar texto dá batida leve, sem andar o carro.
- **Som:** cada batida toca um estalo real de máquina (fatia aleatória do MP3, com variação de tom; mais baixo ao digitar texto) e a retirada da folha toca a troca de linha ("plim") junto com um farfalhar de papel; colocar a folha na máquina toca só o farfalhar. Toca mesmo com movimento reduzido; o botão de alto-falante na frente desliga.
- **Por texto:** o mesmo conjunto, numa folha verde-clara de livro-razão (`.papel.verde`, tokens `--papel-v`/`--papel-v2`); o texto e a prévia ficam na folha e o resumo e os botões na máquina. Trocar entre Formulário e Por texto (`trocarFolha`, ~2,9s): a folha sobe com cuidado até soltar do rolo (450ms), flutua 0,5s, sai voando de lado com giro e some; a nova entra pelo lado oposto, flutua 0,5s acima da máquina e desce com cuidado para o rolo (saída com o "plim" e o papel; entrada só com o papel). Formulário → Por texto anda para a direita; o inverso, para a esquerda. Durante o voo `.maq.voando` solta o recorte lateral e `.main` corta o excesso (`overflow-x: clip`) para não criar rolagem. Cada letra faz o carro andar (até o sino) e Enter faz o retorno com o som da troca de linha.
- **Trava:** erro ao registrar ou item recusado sacode a máquina (320ms).
- **Limpar:** retorno do carro (alavanca + rolo girando, 320ms).
- **Registrar** (`cerimonia`, com os dados já salvos; folha nova sobe do rolo com `alimentar`, 460ms, e o modal abre):
  - Entrada e Saída: retorno do carro com troca de linha (300ms), a folha é arrancada para cima com rolo girando (440ms, ease-in, gira -4°).
  - Descarte: um isqueiro de metal com tampa aberta (SVG `ISQUEIRO`) sobe de baixo à esquerda da folha, falha a ignição 1 ou 2 vezes (roda gira, faíscas, sopro de chama), acende, encosta na borda e fecha a tampa ao sair. A folha queima até sumir (~1,5s): máscara de vários círculos que crescem em velocidades diferentes (borda irregular), anel de brasa, carvão e tostado (`.queima`), chamas, brasas, fumaça e clarão laranja. Som de fogo (`som-fogo.mp3`, baixo).
  - Transferência: a folha sai da máquina e encolhe para uma carta no centro, dobra em três (baixo para cima, depois cima para baixo, mostrando o verso), um envelope pardo entra e a carta desce no bolso; a aba fecha, o lacre roxo é pressionado, o envelope gira mostrando a frente (selo postal "TI", carimbo postal, nº e destino datilografados) e se abre no modal (morph do tamanho do envelope para o do modal).
  - Com movimento reduzido, todos usam só o som de arrancar a folha.

### Documentos: pastas, bloco de notas e lápis
- **Pastas** (catálogo de modelos): pasta de arquivo parda (`--pasta`, `--pasta-2`, interior `--pasta-dentro`, fibra) com aba em trapézio que diz "Padrão" ou "Meu modelo" (aba à esquerda, no meio e à direita, alternando), folhas pautadas espiando do bolso, frente com recorte de polegar, etiqueta creme de filete duplo com o título em Courier caixa alta e descrição a lápis. Giradas ±.7°; no hover endireitam, sobem 4px, a frente cede 9° para fora, as folhas sobem 12px e acende o brilho verde.
- **Abrir uma pasta** (~2,6s, WAAPI): as outras saem para a direita com giro (a mais à direita primeiro, 26ms entre elas) e o cabeçalho esmaece; a escolhida cede (antecipação), sobe num arco e chega perto (escala até 1,25, sombra alta) com o som de folha; a folha do documento de verdade sai do bolso com cuidado (hesita, balança ±1°, a frente cede), com o farfalhar de tirar a folha; a pasta cai de lado e a folha flutua até o lugar da prévia, passa um pouco, sobe 5px e pousa com o som de pousar. O bloco de notas entra pela esquerda girando 1,4°. Com movimento reduzido, abre direto.
- **Bloco de notas** (campos): papel `.papel` sem moldura Déco, espiral de arame (`--metal`) com furos no topo, picote pontilhado, margem dupla vermelha (`--margem`), páginas empilhadas embaixo. Campos sem caixa: linha azul de caderno (`--pauta-forte`), valor a lápis (`--mao`, `--grafite`), textarea pautada. Foco: linha verde de papel.
- **Lápis:** lápis petróleo laqueado com virola de latão e borracha; cada alteração é passada a limpo: o valor fica claro (`--grafite-claro`, rascunho) e o lápis chega de cima, escreve da esquerda para a direita (linha a linha nos textos longos), com tremida leve e raspado de grafite sintetizado, e sobe ao terminar. Escolha passa na hora; texto digitado espera 1s sem digitar ou sair do campo; o campo que muda por consequência (ex.: Para) é escrito em seguida.

### Selo do protocolo (assinatura)
O texto e a tinta do selo dependem do tipo (`SELO_TIPO`): Recebido (verde), Entregue (azul), Transferido (roxo), Descartado (vermelho); vários protocolos de tipos diferentes ficam "Registrados" em verde. A batida toca o som do carimbo. Vindo do envelope (`.envelopado`), o carimbo começa 440ms depois.
O modal com `{ selo }` é a mesma folha de papel, com a lista dos itens registrados datilografada linha a linha (`listaRegistrados`: quantidade ou nº do patrimônio + descrição), que pousa vinda de cima (`papel-pousa`, 420ms, gira de -5° com leve assentamento). Um carimbo Art Déco (`CARIMBADOR`: punho laqueado, anéis de latão, base escalonada, borracha verde) desce acelerando (a partir de 300ms), bate em 580ms com achatamento e sombra no papel, o selo verde de filete duplo girado -9° aparece com a tinta e o modal sente o impacto (`thud`); o carimbo sobe e some (até 1,1s). No celular o selo fica acima do cabeçalho. Ao fechar, só a folha sai (`card-lift`); `.layer-out .modal *` desliga as animações internas para o clone não repetir a entrada.

### Shortcut Cards e KPIs
Atalhos do Painel são cartas com meio-tom e losango de ícone na tinta do movimento, levemente giradas (-.8°, .9°, -.4°); no hover endireitam, sobem 4px e brilham na própria tinta. KPIs e toners também giram ±.5° e se endireitam no hover.

### Layers: modal, gaveta, dropdown, toast
- **Modal:** carta que pousa (`card-drop`, 300ms: sobe 28px, gira de -3.5°, escala de .94); sai levantando (`card-lift`, 180ms). O modal carimbado do registro sai descendo (`papel-desce`, 460ms: recua 10px para cima, depois acelera 64vh para baixo girando até 3.5°), por qualquer via (botões, X, Esc, troca de rota). Moldura Déco igual à do cartão.
- **Gaveta** (só a do patrimônio): é uma folha `.papel` dobrada em três, com vincos leves nas dobras e moldura de filete duplo. Abre como pacote vindo da direita (260ms) mostrando o cabeçalho e desdobra o painel do meio e o de baixo para frente, com sombra de vinco que clareia e leve passada de 6° (~750ms no total); fecha dobrando de baixo para cima e sai pela direita (~620ms). Som de virar página ao abrir e ao fechar. Salvar alterações carimba "SALVO" (verde) e dobra; Saída carimba "SAÍDA" (azul) e a folha é puxada para a esquerda com o farfalhar de tirar a folha; Descartar carimba "DESCARTE" (vermelho) e a folha é amassada numa bola (clip-path irregular + vincos `.rugas`) que dá um pulinho e cai; Devolver ao estoque carimba "DEVOLUÇÃO" (verde) e Transferir carimba "TRANSFERIDO" (roxo), e os dois fecham dobrando. O carimbador é o mesmo do protocolo, com a almofada na tinta do carimbo.
- **Fotos da gaveta:** impressões de borda creme (`--foto-papel`, base mais larga), giradas entre -2° e 2,2° e presas por um clipe de metal (`--metal`) em posições variadas; no hover endireitam e sobem 3px. Arrastar arquivo sobre a gaveta tinge a área de fotos de verde e o bloco "Adicionar" vira "Solte para prender". Foto nova (soltar ou botão) voa do ponto solto, maior e com sombra de altura, num arco curto, pousa com leve passada (340ms) e o clipe desce girando de -16° e morde a borda (240ms, a foto achata 2,5%); várias fotos escalonam até 90ms. Sons: farfalhar curto ao pousar e estalo agudo no clipe.
- **Dropdowns** (busca global, candidatos, details): desdobram de cima com clip-path (180–220ms).
- **Toasts:** deslizam da direita com giro de 2.5° (280ms), saem em 200ms; o de erro é tinta vermelha escura com tremida.
- **Overlay:** véu radial com blur de 2px.

### Motion
Faixa de 120 a 350 ms (a cerimônia do registro, até ~1,1s, é a exceção e roda com os dados já gravados), entrada com `--out` (cubic-bezier(.16, 1, .3, 1)) e saída mais rápida com `--in` (cubic-bezier(.7, 0, .84, 0)). A entrada de página (subida escalonada, título com clip-path, atalhos distribuídos como cartas, medidores enchendo) só roda ao trocar de aba. Em `prefers-reduced-motion`, tudo para, exceto um fade de 150ms nas camadas.

## Do's and Don'ts

### Do:
- **Do** use a tinta do movimento via `--ink` (Entrada verde, Saída azul-gelo, Transferência roxo, Descarte vermelho) em carimbos, segmentados e ícones.
- **Do** mostre status como carimbo torto com `--ink-mask`; reserve o reto e sem máscara para o neutro.
- **Do** ponha números de dado em Bahnschrift Condensed ou Cascadia Mono com algarismos tabulares.
- **Do** emoldure cartões e modais com filete interno e cantoneiras verdes, e divida cabeçalhos com filete duplo de 3px.
- **Do** mantenha o movimento entre 120 e 350 ms, saída mais rápida que entrada, e a entrada de página só na troca de aba.
- **Do** use losangos como marcadores e como fundo de ícones SVG de traço.

### Don't:
- **Don't** crie tema claro nem variante clara; o mundo é só escuro (a folha de papel é objeto, não tema).
- **Don't** use a serifa de cartaz para números, rótulos, botões ou navegação.
- **Don't** deixe uma superfície em repouso brilhar em verde; o brilho é estado.
- **Don't** use fontes web, CDN ou arquivos ao lado; só fontes do Windows ou uma fonte embutida no próprio arquivo.
- **Don't** arredonde em pílula nem passe de 3px em cartões e controles.
- **Don't** incline linhas de tabela, campos ou colunas; inclinar é para peças soltas.
- **Don't** use logos ou nomes da Valve.
