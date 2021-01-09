---
title: Parsing em GO com uso eficiente da memória
date: 2020-10-21T12:00:00-03:00
description:
tags: [go,golang,json,xml,stream]
cover_image: https://miro.medium.com/max/4800/1*xGNVMFqXXTeK7ZyK2eN21Q.jpeg
---

Ao invés de ler todo o fluxo gulosamente em memória e passá-lo para `json.Unmarshal`:

```go
json.Unmarshal(umMonteDeBytes, &minhaStruct)
```

Nós podemos delegar a leitura do fluxo para os nossos queridos mestres da golang:

```go
json.NewDecoder(meuIOReader).Decode(&minhaStruct)
```

E ler arquivos de multi-giga(tera?)bytes sem suor. Também funciona com `xml.NewDecoder`.

_

= M =
