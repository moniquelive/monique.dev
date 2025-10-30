---
title: Passando múltiplos argumentos para sub-templates em golang
date: 2024-01-01T12:00:00-03:00
description: Mostro a truqueira de criar uma função helper no FuncMap para empacotar múltiplos parâmetros ao chamar sub-templates Go.
tags: [go, golang, template, argumentos]
#featuredImage: https://miro.medium.com/max/4800/0*YIWeYQPpPm_bOwVP.png
---

## Resumo
Como criar uma função helper no `FuncMap` para empacotar múltiplos parâmetros ao chamar sub-templates Go.

## O truque do helper
Você já quis passar múltiplos argumentos para um sub-template em go? Se você pesquisar no Google, ficará convencido de que isso não é possível. Mas acompanhe comigo.

Em templates go, você pode passar um único "argumento" (pipeline em golang) para um bloco de "sub-template" definido. Mas, criando uma função auxiliar simples, você pode passar quantos argumentos quiser. Simplesmente adicione esta função ao seu `FuncMap`:

```go
func(els ...any) []any {
    return els
}
```

E você será capaz de criar construções como:

```go
{{ template "MyTemplate" (arr "first" 123 .Some.Value) }}
{{ template "MyTemplate" (arr "second" 456 .Other.Value) }}

{{ define "MyTemplate" }}
  {{ $strArg := index . 0 }}
  {{ $intArg := index . 1 }}
  {{ $valArg := index . 2 }}

  Este é o meu parâmetro str {{ $strArg }}.
  ...
{{ end }}
```

Eu chamei a minha função auxiliar de `arr`, mas você pode chamá-la como quiser.

## Onde uso
Uso quando quero renderizar listas com dados diferentes ou mesclar strings e números sem abrir structs só para isso. Fica enxuto e continua idiomático.

Aproveite!

_

= M =
