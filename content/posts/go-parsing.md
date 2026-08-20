---
title: Parsing em Go com uso eficiente da memória
date: 2020-10-21T12:00:00-03:00
description: >-
  Explico como json.Decoder e xml.Decoder leem de um io.Reader e quando é necessário
  percorrer tokens ou elementos para limitar o uso de memória.
tags: [go,golang,json,xml,stream]
---

## Resumo
Como usar `json.Decoder` e `xml.Decoder` com um `io.Reader` e entender os limites dessa abordagem.

## Decodificando a partir de um io.Reader
Ao invés de ler todo o fluxo gulosamente em memória e passá-lo para `json.Unmarshal`:

```go
if err := json.Unmarshal(umMonteDeBytes, &minhaStruct); err != nil {
    return err
}
```

Nós podemos delegar a leitura do fluxo para os nossos queridos mestres da golang:

```go
if err := json.NewDecoder(meuIOReader).Decode(&minhaStruct); err != nil {
    return err
}
```

Essa API evita que seu código chame `io.ReadAll`, mas `Decode` ainda armazena o próximo valor JSON completo antes de preencher o destino. Um objeto gigante pode ocupar memória tanto na forma codificada quanto na estrutura Go.

Para limitar o uso de memória, percorra os tokens ou decodifique os elementos de um array individualmente:

```go
dec := json.NewDecoder(meuIOReader)
if _, err := dec.Token(); err != nil { // abre o array
    return err
}

for dec.More() {
    var item Item
    if err := dec.Decode(&item); err != nil {
        return err
    }
    process(item)
}

_, err := dec.Token() // fecha o array
return err
```

A mesma ressalva vale para `xml.Decoder`: percorra os tokens quando o documento inteiro não puder ficar na memória.

## Quando lembrar disso
Quando a entrada vier de um `io.Reader` — arquivo, pipe de rede ou `stdin` — o decoder simplifica a API. Para reduzir o pico de memória de verdade, processe cada unidade e descarte-a antes de ler a próxima.

_

= M =
