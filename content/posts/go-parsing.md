---
title: Memory efficient parsing in GO
date: 2021-01-08T12:01:00-03:00
description:
tags: [go,golang,json,xml,stream]
cover_image: https://miro.medium.com/max/4800/1*xGNVMFqXXTeK7ZyK2eN21Q.jpeg
---

Instead of greedily reading the whole stream in memory and passing it to `json.Unmarshal`:

```go
json.Unmarshal(bigBlobOfData, &myStruct)
```

We can delegate the stream reading to our dear masters of golang:

```go
json.NewDecoder(myIOReader).Decode(&myStruct)
```

And read multi giga(tera?)bytes files with no sweat. Also works with `xml.NewDecoder`.
