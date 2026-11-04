# Almoxarifado TI

Controle de estoque, toners e patrimônios da TI da SASC. É um app web **offline de arquivo único** (HTML + CSS + JS puro, sem framework, sem dependências e sem servidor), pensado para uso diário em um único PC, com identidade visual Art Déco noturna.

## Funcionalidades

- Lançamento de entradas, saídas, transferências e descartes, com protocolo numerado.
- Estoque de itens e toners que nunca fica negativo; só o protocolo mais recente pode ser desfeito.
- Cadastro de patrimônios (5 ou 6 dígitos, sem duplicados, com opção S.P.) por unidade e setor.
- Recibo de protocolo para impressão em duas vias (saída e transferência).
- Busca rápida, compatível com leitor de código de barras.
- Backup e restauração em `.json`, incluindo fotos.

## Como usar

1. Abra `Almoxarifado TI.html` no navegador (duplo clique).
2. Os dados ficam salvos no IndexedDB do próprio navegador; faça backups periódicos pela interface.

Não há instalação nem conexão com a internet.

## Desenvolvimento

O código-fonte fica em `src/app.html`. O arquivo `Almoxarifado TI.html` é **gerado**, não o edite diretamente.

```powershell
# Gera o entregável (junta app.html + seed.json + sons em base64)
& ".\build.ps1"

# Regera o seed a partir da planilha, depois rode o build
& ".\tools\extrair-planilha.ps1" -Planilha "Controle de almoxarifado TI SASC.xlsx"
```

Os dados iniciais vieram da planilha `Controle de almoxarifado TI SASC.xlsx`.

## Estrutura

| Caminho | Conteúdo |
| --- | --- |
| `src/` | Código-fonte, seed e sons |
| `tools/` | Scripts auxiliares em PowerShell |
| `build.ps1` | Build do HTML único |
| `docs/context/` | Documentação de contexto do projeto |
| `DESIGN.md`, `PRODUCT.md` | Identidade visual e definição do produto |
