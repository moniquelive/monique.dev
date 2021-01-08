---
title: "Haskell LSP (bonus: for Vim)"
date: 2021-01-08T17:22:20-03:00
tags: [haskell,vim,lsp]
cover_image: https://www.techort.com/wp-content/uploads/2019/01/applicative-parsers-on-haskell-habr.png
---

So you enjoy coding in Haskell. And you heard kids nowadays code using this [LSP][lsp] thingy.

Let's cut to the chase: LSP is a spec that standardizes auto-completion, code navigation, linting, and all good stuff usually found in modern IDE's. In order to use LSP with your favorite language you'll need a language server to communicate with your editor of choice.

In this article we'll focus on [haskell's language server][hls]. Not long ago the language server of choice used to be `hie` but now it's deprecated.

So let's get started! Assuming you have Haskell Stack up and running:

```bash
$ stack install ghcid hspec-discover # optional but great
$ git clone https://github.com/haskell/haskell-language-server --recurse-submodules
$ cd haskell-language-server
$ stack ./install.hs help
$ stack ./install.hs hls
```
The binaries we'll be at the usual place: `~/.local/bin`

Right, but how do I use it? Well it depends on your editor. Let me show you how I do it in my `.vimrc`:

```VimL
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
```

Please read their documentation!

```VimL
" vim-lsp-settings won't detect hls automatically as of today (2020-10-26). Let's teach it:
if (executable('haskell-language-server-wrapper'))
  au User lsp_setup call lsp#register_server({
      \ 'name': 'haskell-language-server-wrapper',
      \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
      \ 'whitelist': ['haskell'],
      \ })
endif

" My Mappings
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

    " buffer format on save
    " autocmd BufWritePre <buffer> LspDocumentFormatSync
endfunction

" Decorations
augroup lsp_install
    au!
    let g:lsp_signs_enabled = 1         " enable signs
    let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
    let g:lsp_signs_error = {'text': '✗'}
    " let g:lsp_signs_warning = {'text': '‼', 'icon': '/path/to/some/icon'} " icons require GUI
    " let g:lsp_signs_hint = {'icon': '/path/to/some/other/icon'} " icons require GUI
    let g:lsp_signs_warning = {'text': '‼'}
    let g:lsp_highlight_references_enabled = 1
    highlight link LspErrorText GruvboxRedSign " requires gruvbox
    highlight clear LspWarningLine
    " highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green
    highlight lspReference guibg=#303010

    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
```

The first time you start vim with a Haskell file it'll take a while (you can check vim-lsp's status with `:LspStatus`). As soon as a left margin (1 character wide) shows up, you're good to go!

Now your Vim is an LSP powerhouse:

* Hover:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/ldga2jmvzlj9epp0rjf8.png)

* Auto-complete:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/yhiu4kww6paaehuisp20.png)

etc. etc. etc.

Enjoy!

[lsp]: https://microsoft.github.io/language-server-protocol/ "Language Server Protocol"
[hls]: https://github.com/haskell/haskell-language-server "Haskell Language Server"
