# Estado atual

## Entregue
Primeira versão completa em `Almoxarifado TI.html`: Painel (com computadores, monitores e impressoras ativos por local), Lançar (protocolo com vários itens, recibo impresso; modo "Por texto" com uma movimentação por linha, ex.: `transferencia computador 33333 cras 1 para cras 2 hoje`, e prévia antes de gravar), Itens, Toners (consumo por unidade em 6 meses), Patrimônios (Todos, CPU/Notebook, Monitores, Impressoras com total própria/locada por unidade, Estabilizadores, Outros; cadastro de bens já em uso um a um ou em lote, digitando o nº e, se quiser, a marca de cada um; fotos na gaveta do bem, com ícone de câmera na tabela), Movimentações (com desfazer do último protocolo), Descarte, Configurações (unidades, setores, categorias, numeração de protocolo, backup/restauração, apagar todos os patrimônios para recadastrar do zero, restaurar dados da planilha), busca global, identidade visual Art Déco noturna (só tema escuro, com animações) e layout de celular.

Carga inicial: patrimônios da planilha importados (ativos e descartados), catálogo de itens e toners com mínimos e quantidades zeradas, protocolos começando no nº 1. 13 patrimônios marcados "Conferir" por inconsistências da planilha (números repetidos, presentes no Descarte e ativos ao mesmo tempo, impressora 000039 repetida, impressora sem própria/locada, projetor com 7 dígitos).

## Pendências
Nenhuma. O repositório git fica na pasta pai `Projetos/`; faça commit só dos caminhos desta pasta.

## Limitações conhecidas
- Dados só no navegador daquele PC; limpar dados do navegador apaga tudo. A proteção é o backup `.json` (o painel avisa após 7 dias sem backup).
- Abrir o arquivo em outro navegador ou outro PC começa do zero (a partir do seed).
- Só o protocolo mais recente pode ser desfeito.
- Sem migração de versão do formato de dados (`versao: 1`).
- Enter num nº de patrimônio desconhecido em "Lançar" deve abrir o cadastro de novo patrimônio; funcionou por evento simulado, com teclado real (não verificado).
