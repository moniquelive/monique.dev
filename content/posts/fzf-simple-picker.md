---
title: Usando fzf para escolher de uma lista de opções
date: 2024-01-02T12:00:00-03:00
description: >-
  Bato papo sobre jeitos reais de usar fzf como seletor interativo, desde limpar imagens
  Docker até pré-visualizar temas do Pygments.
tags: [fzf, shell, docker, pygments]
---

## Resumo
Jeitos reais de usar fzf como seletor interativo, desde limpar imagens Docker até pré-visualizar temas do Pygments.

Alguns cenários em que uso fzf para me ajudar a escolher de uma lista de opções

## 1. Escolhendo quais imagens Docker eu gostaria de remover

```shell
fzfrmimage () {
  # - listar todas as imagens docker, pulando a primeira linha
  # - alimentar essas linhas no fzf (usuário: selecionar com TAB/pressionar ENTER)
  # - formatar uma lista de 'imagem:tag' e passá-la para `docker image rm`
  images=$(docker image ls | tail -n +2 | fzf | sed -n 's/\(\S*\) *\(\S*\).*/\1:\2/p')
  docker image rm $(echo $images)
}
```
<br/>

---

## 2. Escolhendo entre os temas do Pygments (estilos)

Usei isso como uma linha de comando (na verdade 2 para melhor legibilidade) para visualizar um código de exemplo usando o estilo.

```shell
pygmentize -L styles | sed -n 's/^* \(.*\):/\1/p' |\
  fzf --preview "pygmentize -P style={} -l python ~/prj/python/bored/main.py"
```

- listar todos os estilos
- filtrar linhas que começam com um asterisco
- remover o caractere ':' ao final
- passar a lista pro fzf junto com o código de exemplo
- usuário: selecionar com TAB / pressionar ENTER
- fzf imprime os temas selecionados
- sucesso!

O FZF é uma ferramenta super flexível que eu sempre procuro maneiras de aproveitar seus poderes. Obrigado [Junegunn Choi](https://github.com/junegunn) por criá-lo!

_

= M =
