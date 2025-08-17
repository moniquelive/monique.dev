# Tema Hugo — Lírio

Um tema **mobile-first**, **elegante** e **minimalista** com um toque feminino.

## Instalação

```bash
# Dentro do seu repositório monique.dev
git submodule add https://example.com/moniquelive/hugo-theme-lirio themes/lirio
# ou copie a pasta para themes/lirio
```

No `config.toml` (ou `hugo.toml`):

```toml
baseURL = "https://monique.dev"
theme = "lirio"

[params]
  colorScheme = "auto"   # light | dark | auto
  showTOC = true
  showDates = true
  showEstimatedReadingTime = true
```

## Desenvolvimento

```bash
hugo server -D
```

## Estrutura

- `assets/css/lirio.css` — CSS leve com variáveis e utilitários
- `layouts/_default/{baseof,list,single}.html` — Estruturas principais
- `layouts/partials/{head,header,footer,toc,pagination}.html` — Parciais
- `static/{favicon.svg,logo.svg}` — Ícones

## Licença

MIT
