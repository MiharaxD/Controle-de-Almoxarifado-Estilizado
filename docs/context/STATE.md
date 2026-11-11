# Estado atual

## Entregue
Primeira versão completa em `index.html`: Painel (com computadores, monitores e impressoras ativos por local), Lançar (protocolo com vários itens, recibo impresso; modo "Por texto" com uma movimentação por linha, ex.: `transferencia computador 33333 cras 1 para cras 2 hoje`, e prévia antes de gravar), Itens, Toners (consumo por unidade em 6 meses), Patrimônios (Todos, CPU/Notebook, Monitores, Impressoras com total própria/locada por unidade, Estabilizadores, Outros; cadastro de bens já em uso um a um ou em lote, digitando o nº e, se quiser, a marca de cada um; fotos na gaveta do bem, com ícone de câmera na tabela), Movimentações (com desfazer do último protocolo), Descarte, Documentos (7 modelos com timbre da Prefeitura: C.I de envio de equipamento, C.I de devolução após manutenção, C.I de comunicado/relatório, requisição de material, protocolo de entrega, termo de responsabilidade e memorando; catálogo agrupado por situação; "Gerar documento" no protocolo (Movimentações e modal do registro) e na gaveta do patrimônio abre o modelo já preenchido; preenchimento e PDF numa tela só, com campos principais primeiro e "Detalhes" recolhido, erro por campo, rascunho que sobrevive a recarregar, abas Campos/Folha no celular; numeração pergunta o último nº do ano e só avança quando o usuário confirma que o PDF foi salvo; modelos editáveis em "Gerenciar modelos": criar, editar, duplicar, remover e restaurar os padrão), Configurações (unidades, setores, categorias, numeração de protocolo, backup/restauração, apagar todos os patrimônios para recadastrar do zero, restaurar dados da planilha), busca global, identidade visual Art Déco noturna (só tema escuro, com animações) e layout de celular.

Carga inicial: patrimônios da planilha importados (ativos e descartados), catálogo de itens e toners com mínimos e quantidades zeradas, protocolos começando no nº 1. 13 patrimônios marcados "Conferir" por inconsistências da planilha (números repetidos, presentes no Descarte e ativos ao mesmo tempo, impressora 000039 repetida, impressora sem própria/locada, projetor com 7 dígitos).

## Pendências
- Documentos: no banco real, responder ao aviso de numeração na primeira C.I do ano (no papel a C.I já ia no 08).

O app fica na raiz do repositório git (`Projetos/`); as outras pastas ali (`Controle TI/`, `Manin/`, `teste/` etc.) são outros projetos, não rastreados: faça commit só dos arquivos do app.

## Limitações conhecidas
- Dados só no navegador daquele PC; limpar dados do navegador apaga tudo. A proteção é o backup `.json` (o painel avisa após 7 dias sem backup).
- Abrir o arquivo em outro navegador ou outro PC começa do zero (a partir do seed).
- Só o protocolo mais recente pode ser desfeito.
- Sem migração de versão do formato de dados (`versao: 1`).
- Documentos: o rascunho fica no `sessionStorage` (some ao fechar a aba do navegador); o app não sabe se a impressão foi cancelada, por isso pergunta antes de avançar a numeração; a prévia não marca onde cai a quebra de página automática (só a impressão mostra; `[quebra]` aparece como linha tracejada). Impressão de `[quebra]` e de modelo criado no editor não conferida na prévia de impressão (não há Chrome/Edge headless nesta máquina). Requisição com mais de ~10 itens passa o rodapé para a 2ª página.
- Enter num nº de patrimônio desconhecido em "Lançar" deve abrir o cadastro de novo patrimônio; funcionou por evento simulado, com teclado real (não verificado).
