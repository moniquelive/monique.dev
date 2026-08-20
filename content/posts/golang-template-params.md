---
title: Passando múltiplos argumentos para sub-templates em Go
date: 2024-01-01T12:00:00-03:00
description: >-
  Mostro a truqueira de criar uma função helper no FuncMap para empacotar múltiplos
  parâmetros ao chamar sub-templates Go.
tags: [go, golang, template, argumentos]
---

## Resumo
Como criar uma função helper no `FuncMap` para empacotar múltiplos parâmetros ao chamar sub-templates Go.

## O truque do helper
Você já quis passar múltiplos argumentos para um sub-template em go? Se você pesquisar no Google, ficará convencido de que isso não é possível. Mas acompanhe comigo.

Em templates Go, você pode passar um único valor de pipeline para um sub-template. Uma função auxiliar permite empacotar vários valores nesse valor único. Registre a função no `FuncMap` antes de analisar um template que use `arr`:

```go
funcMap := template.FuncMap{
    "arr": func(els ...any) []any {
        return els
    },
}

tmpl := template.Must(
    template.New("root").Funcs(funcMap).Parse(src),
)
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

Eu chamei a função auxiliar de `arr`, mas você pode usar outro nome. Ela não passa vários argumentos reais: empacota os valores em um `[]any`, que se torna o valor corrente (`.`) do sub-template.

## Onde uso
Uso quando quero renderizar listas com dados diferentes ou mesclar strings e números sem abrir structs só para isso. Fica enxuto e continua idiomático.

Aproveite!

_

= M =
