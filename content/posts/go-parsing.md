---
title: Parsing em GO com uso eficiente da memória
date: 2020-10-21T12:00:00-03:00
description: Explico por que vale usar json.NewDecoder (e cia) para fazer streaming de dados gigantes em Go sem estourar memória.
tags: [go,golang,json,xml,stream]
cover_image: https://miro.medium.com/max/4800/1*xGNVMFqXXTeK7ZyK2eN21Q.jpeg
---

## Resumo
Por que vale usar `json.NewDecoder` (e cia) para fazer streaming de dados gigantes em Go sem estourar memória.

## Decodificando sem copiar tudo
Ao invés de ler todo o fluxo gulosamente em memória e passá-lo para `json.Unmarshal`:

```go
json.Unmarshal(umMonteDeBytes, &minhaStruct)
```

Nós podemos delegar a leitura do fluxo para os nossos queridos mestres da golang:

```go
json.NewDecoder(meuIOReader).Decode(&minhaStruct)
```

E ler arquivos de multi-giga(tera?)bytes sem suor. Também funciona com `xml.NewDecoder`.

## Quando lembrar disso
Sempre que o input vier de `io.Reader` (arquivo enorme, pipe de rede, stdin), deixar o decoder cuidar do streaming evita peaks de memória e fica mais elegante.

_

= M =
