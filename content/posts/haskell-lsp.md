---
title: "LSP de Haskell (bonus: com Vim)"
date: 2020-10-26T12:00:00-03:00
tags: [haskell,vim,lsp]
cover_image: https://www.techort.com/wp-content/uploads/2019/01/applicative-parsers-on-haskell-habr.png
---

Então você curte codar em Haskell. E você ouviu dizer que os jovens hoje em dia usam esse negócio chamado [LSP][lsp].

Direto ao ponto: `LSP` é uma especificação que padroniza o auto-complete, navegação no código, linting, essas facilidades normalmente encontradas somente em IDE's. E pra usar o tal do `LSP` é preciso ter um _servidor de linguagem_ que se comunica com o seu editor preferido.

Neste artigo vamos focar no `LSP` de Haskell ([haskell's language server][hls]). Há um tempo atrás o `LSP` padrão de Haskell era o `HIE`, mas foi descontinuado.

Vamos começar então! Assumindo que você tem o [Haskell Stack][stack] instalado:

```bash
$ stack install ghcid hspec-discover # opcional mas recomendado
$ git clone https://github.com/haskell/haskell-language-server --recurse-submodules
$ cd haskell-language-server
$ stack ./install.hs help
$ stack ./install.hs hls
```
Os binários são instalados em `~/.local/bin`

Certo, mas como usá-lo agora? Bem, depende do seu editor. Vou mostrar como faço no meu `.vimrc`:

```VimL
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
```

Leia a documentação destes plugins para tirar melhor proveito deles!

```VimL
" o plugin vim-lsp-settings não detecta o hls automaticamente. Vamos ensinar pra ele:
if (executable('haskell-language-server-wrapper'))
  au User lsp_setup call lsp#register_server({
      \ 'name': 'haskell-language-server-wrapper',
      \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
      \ 'whitelist': ['haskell'],
      \ })
endif

" Meus atalhos
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gf <plug>(lsp-code-action)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <F2> <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    xmap <buffer> f <plug>(lsp-document-range-format)
    nmap <buffer> <F5> <plug>(lsp-code-lens)

    " reformatar sempre ao gravar (as vezes irritante)
    " autocmd BufWritePre <buffer> LspDocumentFormatSync
endfunction

" Decorações
augroup lsp_install
    au!
    let g:lsp_signs_enabled = 1                                             " liga signs
    let g:lsp_diagnostics_echo_cursor = 1                                   " liga ecoar sob o cursor no modo normal
    let g:lsp_signs_error = {'text': '✗'}
    " let g:lsp_signs_warning = {'text': '‼', 'icon': '/path/to/some/icon'} " ícones só na versão gráfica
    " let g:lsp_signs_hint = {'icon': '/path/to/some/other/icon'}           " ícones só na versão gráfica
    let g:lsp_signs_warning = {'text': '‼'}
    let g:lsp_highlight_references_enabled = 1
    highlight link LspErrorText GruvboxRedSign " requires gruvbox
    highlight clear LspWarningLine
    " highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green
    highlight lspReference guibg=#303010

    " chama s:on_lsp_buffer_enabled somente para linguagens cadastradas no LSP
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
```

A primeira vez que iniciar o vim com um arquivo Haskell vai levar um tempinho pra carregar (verifique o status com `:LspStatus`). Assim que a margem esquerda do editor ficar com um espaço de 1 letra quer dizer que funcionou!

Agora seu Vim fala `LSP`:

* Hover:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/ldga2jmvzlj9epp0rjf8.png)

* Auto-complete:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/yhiu4kww6paaehuisp20.png)

etc. etc. etc.

_

= M =

[lsp]: https://microsoft.github.io/language-server-protocol/ "Language Server Protocol"
[hls]: https://github.com/haskell/haskell-language-server "Haskell Language Server"
[stack]: https://docs.haskellstack.org/en/stable/README/ "Haskell Stack"
