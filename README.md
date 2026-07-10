# monique.dev

Código-fonte do site pessoal [monique.dev](https://monique.dev/), construído com Hugo e o tema
local Lirio.

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
mise run ci           # executa validação e build de produção
mise run links        # gera o site e valida links internos
mise run clean        # remove arquivos gerados pelo Hugo
npm run format:check  # confere a formatação do CSS
```

Para conferir conteúdo ainda não publicado, use `hugo list drafts`.

## Publicação

O site é hospedado no Cloudflare Workers. O arquivo `wrangler.toml` define o build e a pasta de
assets; no ambiente do Cloudflare, `build.sh` instala a versão fixada do Hugo e gera `public/`.
