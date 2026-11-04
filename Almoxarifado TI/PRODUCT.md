# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users
Equipe de TI da SASC, num único PC, durante o expediente: lança entradas, saídas, transferências e descartes, confere estoque de itens e toners e localiza patrimônios por unidade e setor.

## Product Purpose
Controle de estoque, toners e patrimônios da TI da SASC sem servidor nem login. Sucesso é achar um patrimônio ou registrar um protocolo em segundos, com estoque que nunca fica negativo e histórico confiável.

## Operating Context
Uso diário e repetitivo, com teclado e leitor de código de barras no campo de busca do "Lançar". Recibo de protocolo impresso em duas vias (Saída e Transferência). Backup manual em `.json`.

## Capabilities and Constraints
- Arquivo HTML único e offline (HTML + CSS + JS puro), sem CDN, fontes web ou arquivos ao lado.
- Dados no IndexedDB do navegador; backups antigos precisam continuar restauráveis.
- Patrimônio com 5 ou 6 dígitos, zeros à esquerda, sem duplicados; S.P. permitido; nº da locadora separado.
- Só o protocolo mais recente pode ser desfeito.
- Textos da interface em português do Brasil.

## Brand Commitments
- Nome: "Almoxarifado TI", unidade "SASC".
- Identidade visual inspirada no dossiê de Deadlock fornecido pelo usuário (Art Déco + ocultismo noturno, verde "gaslamp", cartaz impresso, carimbos), em imersão total e só tema escuro. Sem logos ou nomes da Valve.

## Evidence on Hand
Dados reais vêm da planilha `Controle de almoxarifado TI SASC.xlsx` (em `src/seed.json`). Não há outros ativos de marca.

## Product Principles
- Rapidez de lançamento acima de tudo: nenhum efeito pode atrasar digitar e registrar.
- Estado sempre legível: estoque baixo, zerado, conferir e tipo de movimento reconhecíveis à primeira vista.
- Nada se perde: avisar antes de descartar o que foi digitado e lembrar do backup.

## Accessibility & Inclusion
Contraste AA no texto, foco visível, navegação por teclado e caminho para `prefers-reduced-motion`.
