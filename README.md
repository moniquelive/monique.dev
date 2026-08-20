# monique.dev

Código-fonte do site pessoal [monique.dev](https://monique.dev/), construído com Hugo e o tema
local Lírio Pop.

## Desenvolvimento

O projeto usa [mise](https://mise.jdx.dev/) para fixar as versões das ferramentas. Depois de clonar
o repositório:

```sh
mise install
npm ci
mise run dev
```

O servidor local inclui rascunhos e recarrega os templates por completo.

## Comandos

```sh
mise run test         # valida o site e exibe avisos de caminhos
mise run build        # gera a versão de produção em public/
mise run ci           # valida dependências, conteúdo, build e links internos
mise run links        # gera o site e valida links internos
mise run clean        # remove arquivos gerados pelo Hugo
npm run format:check  # confere a formatação do CSS
```

Para conferir conteúdo ainda não publicado, use `hugo list drafts`.

## Publicação

O site é hospedado no Cloudflare Workers. O arquivo `wrangler.toml` define o build e a pasta de
assets; durante o deploy, `build.sh` instala a versão fixada do Hugo e gera `public/`. O deploy usa
a versão do Wrangler fixada no `package.json`.
