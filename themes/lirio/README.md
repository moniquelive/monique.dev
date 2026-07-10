# Tema Hugo — Lírio

Tema local, mobile-first e minimalista do `monique.dev`.

O Lírio é versionado diretamente neste repositório em `themes/lirio/`; ele não é um
submódulo Git nem uma dependência de Hugo Modules. Alterações específicas do site
podem ser feitas em `layouts/`, que tem precedência sobre os templates do tema.

## Desenvolvimento

Use as tarefas do projeto na raiz do repositório:

```bash
mise install
mise run dev
mise run test
```

## Estrutura

- `assets/css/lirio.css` — estilos, variáveis e utilitários do tema.
- `layouts/_default/` — templates base, de lista e de página.
- `layouts/partials/` — cabeçalho, metadados, cards, rodapé, sumário e paginação.
- `layouts/about/` — apresentação da página Sobre.
- `static/` — favicons, manifesto e logotipo publicados sem transformação.

## Parâmetros usados

- `colorScheme`: `light`, `dark` ou `auto`.
- `showTOC`: exibe o sumário nas páginas.
- `showDates`: exibe a data dos posts.
- `showEstimatedReadingTime`: exibe o tempo estimado de leitura.
- `singleDateFormat`, `listDateFormat` e `indexDateFormat`: formatos de data do Hugo.
- `mainSections`: seções tratadas como posts; o padrão é `posts`.

## Licença

MIT
