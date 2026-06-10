---
title: Encontrando man pages pelo Neovim com Telescope e/ou mini.pick
date: 2026-06-05T12:00:00-03:00
description: Um plugin pequeno para Neovim que descobre man pages locais com apropos e abre tudo pelo comando :Man nativo do Neovim.
tags: [neovim, lua, telescope, vim]
draft: true
---

## Resumo

Um plugin pequeno para Neovim que descobre man pages locais com `apropos` e abre tudo pelo comando `:Man` nativo do Neovim.

Eu uso man pages o tempo todo, mas às vezes não sei exatamente o que quero abrir.

`printf` é um bom exemplo.

Existe `printf(1)` para o comando de shell, `printf(3)` para a função da biblioteca C e, dependendo do que está instalado localmente, pode haver ainda mais entradas relacionadas.

Eu queria algo simples dentro do Neovim:

- listar man pages locais
- fazer busca fuzzy nelas
- ver a seção antes de abrir
- abrir usando o `:Man` nativo do Neovim

Então fiz um plugin pequeno: `man.nvim`.

Código-fonte:

- GitHub: [https://github.com/moniquelive/man.nvim](https://github.com/moniquelive/man.nvim)

## O que ele faz

O plugin começa pelo banco de dados do sistema:

```bash
apropos .
```

Depois ele faz o parsing da saída em itens para o picker, como:

```text
[1 User commands] printf(1) - format and print data
[3 Library calls] printf(3) - formatted output conversion
```

A parte importante é que selecionar uma entrada ainda delega a abertura para o Neovim:

```vim
:Man 3 printf
```

Sem renderer customizado.
Sem buffer de terminal fingindo ser `man`.
Sem reimplementar navegação de man page.

Só descoberta por um picker e abertura pelo `:Man`.

## Por que não usar só :Man?

`:Man` é ótimo quando eu já sei o que quero.

Mas muitas vezes quero explorar o que está instalado localmente. Posso lembrar parte do nome, da descrição ou da seção.

Com o picker, consigo digitar coisas como:

```text
printf
3 printf
formatted output
```

E o texto do item inclui o rótulo da seção, então fica fácil ver se estou prestes a abrir o comando, a chamada de biblioteca, o formato de arquivo etc.

## Versão com Telescope

A branch `main` expõe uma extensão do Telescope.

Setup:

```lua
require('telescope').setup()
require('man_nvim').setup()
```

Uso:

```vim
:Telescope man
```

Internamente, ela usa um table finder. Cada man page parseada vira uma entrada com dados como:

```lua
{
  name = 'printf',
  section = '3',
  ref = 'printf(3)',
  description = 'formatted output conversion',
}
```

O display e o ordinal usam o mesmo texto pesquisável:

```text
[3 Library calls] printf(3) - formatted output conversion
```

Isso deixa o Telescope fazer o que ele faz bem: prompt, ordenação, preview e mappings.

## Versão com mini.pick

Também existe uma branch `mini.picker` usando `mini.pick`.

Setup:

```lua
require('mini.pick').setup()
require('man_nvim').setup()
```

Uso:

```vim
:Pick man
```

A parte interessante é que a maior parte do plugin é conceitualmente compartilhada:

- fazer o parsing da saída do `apropos`
- separar aliases
- ordenar por seção de man page
- montar o comando `:Man`
- mostrar um preview pequeno
- abrir a página selecionada

Só a integração com o picker muda.

## Aliases

Algumas entradas do `apropos` têm muitos aliases.

Por exemplo, shells podem produzir linhas como:

```text
builtin(1), !(1), %(1), .(1), :(1), [(1) - shell built-in commands
```

O plugin cria itens pesquisáveis para os aliases, mas abre a página canônica.

Então, se eu procurar por `!`, consigo encontrar `!(1)`, mas selecionar esse item abre `builtin(1)`.

Isso importa porque alguns aliases não são man pages independentes de verdade. Eles são documentados na primeira entrada daquela linha do `apropos`.

## Filtrando resultados barulhentos

Uma coisa que ficou irritante muito rápido: resultados de Tcl/Tk.

Às vezes uma busca como `format` mostra resultados úteis, mas também um monte de entradas relacionadas a Tcl que não me interessam naquele momento.

Então adicionei termos negativos no prompt.

Nas versões com Telescope e mini.pick:

```text
format -tcl
format -tcl -tk
```

Isso significa:

- procurar por `format`
- excluir entradas contendo `tcl`
- opcionalmente excluir também `tk`

Os termos negativos também usam smartcase:

```text
-tcl  # exclui tcl, Tcl, TCL etc quando o smartcase permite
-Tcl  # exclusão case-sensitive
```

A versão com Telescope implementa isso como um wrapper do sorter. Ela remove os termos negativos do prompt, filtra as entradas e depois delega a busca positiva de volta para o sorter normal do Telescope.

A versão com mini.pick implementa isso como um `source.match` customizado. Ela filtra as entradas primeiro e depois passa a busca positiva de volta para `MiniPick.default_match`.

Assim eu mantenho o comportamento normal de matching de cada picker, em vez de substituir tudo por um fuzzy matcher meu.

## Mappings de abertura

Os mappings são propositalmente sem graça:

```text
<CR>  :vertical Man {section} {name}
<C-x> :Man {section} {name}
<C-v> :vertical Man {section} {name}
<C-t> :tab Man {section} {name}
```

`<CR>` abre verticalmente por padrão porque é assim que normalmente quero a documentação ao lado do código.

`<C-x>` abre com o `:Man` normal, para o hábito clássico de split horizontal.

## Notas de portabilidade

O plugin tenta funcionar em macOS, Linux e FreeBSD.

Isso significa principalmente evitar suposições espertas demais.

A saída do `apropos` pode ser barulhenta. Na minha máquina macOS, vi linhas como `makewhatis: ... No such file or directory`, então o parser simplesmente ignora linhas que não parecem entradas de man page.

As seções também nem sempre são só `1` até `9`. Podem existir coisas como:

```text
3p
3posix
n
```

Então o parser aceita nomes de seção dentro dos parênteses em vez de assumir um único dígito.

Para abrir as páginas, o plugin deixa o Neovim e o comando `man` do sistema cuidarem da parte difícil.

## Instalação

Com [lazy.nvim](https://github.com/folke/lazy.nvim), para a versão com Telescope:

```lua
{
  'moniquelive/man.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('man_nvim').setup()
  end,
}
```

Para a versão com `mini.pick`:

```lua
{
  'moniquelive/man.nvim',
  branch = 'mini.picker',
  dependencies = { 'echasnovski/mini.pick' },
  config = function()
    require('mini.pick').setup()
    require('man_nvim').setup()
  end,
}
```

Com [packer.nvim](https://github.com/wbthomason/packer.nvim), para Telescope:

```lua
use({
  'moniquelive/man.nvim',
  requires = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('man_nvim').setup()
  end,
})
```

Para `mini.pick`:

```lua
use({
  'moniquelive/man.nvim',
  branch = 'mini.picker',
  requires = { 'echasnovski/mini.pick' },
  config = function()
    require('mini.pick').setup()
    require('man_nvim').setup()
  end,
})
```

Com [vim-plug](https://github.com/junegunn/vim-plug), para Telescope:

```vim
Plug 'nvim-telescope/telescope.nvim'
Plug 'moniquelive/man.nvim'
```

Depois, em algum lugar após os plugins carregarem:

```lua
require('man_nvim').setup()
```

Para `mini.pick`:

```vim
Plug 'echasnovski/mini.pick'
Plug 'moniquelive/man.nvim', { 'branch': 'mini.picker' }
```

Depois:

```lua
require('mini.pick').setup()
require('man_nvim').setup()
```

## Considerações finais

É um plugin pequeno, mas encaixou bem no meu workflow.

Eu não queria substituir o `man`.
Eu só queria uma forma melhor de descobrir man pages locais de dentro do Neovim.

Telescope e mini.pick funcionam bem para isso. A parte divertida foi manter o comportamento central simples e mudar só a camada do picker.

Se eu estender isso depois, talvez adicione um fallback por sistema de arquivos para máquinas em que o banco do `apropos` esteja ausente ou desatualizado.

Mas, por enquanto: busca fuzzy na documentação local, filtro para tirar ruído e abertura com `:Man`.

Profit!

_

= M =
