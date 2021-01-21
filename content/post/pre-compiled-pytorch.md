---
title: Versões pré-compiladas de Pytorch
date: 2021-01-20T15:00:00-03:00
tags: [python, pytorch, cuda, gpu]
cover_image: https://upload.wikimedia.org/wikipedia/commons/9/96/Pytorch_logo.png
---

Acabo de descobrir um repositório que salvou minha pele, então resolvi vir aqui compartilhar com vocês.

Se você abrir o site do `pytorch`, ele te apresenta algumas opções de instalação:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/oixb0x4hndw3ddm10gub.png)

A questão é que, se você quiser instalar uma versão diferente da apresentada (hoje é a 1.7.1), vai começar uma caça ao tesouro bem chatinha...

Existe uma página - que sei lá o porquê me levou um tempo pra achar - aqui:

```shell
https://download.pytorch.org/whl/torch_stable.html
```

Mas não é necessário abrir esse link! Você pode pedir ao `pip` pra buscar pra você:

```shell
pip[3] install pytorch==1.6.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html
```

E voilá, seu pacote vai ser instalado automagicamente ;)

Algumas dicas extras:

1. Algumas versões de `cuda` são consideradas "default". Por exemplo, se você procurar por `1.6.0+cu102` não vai ter lá, porque `pip install cuda==1.6.0` vai buscar automaticamente a versão com cuda `10.2`.

2. Se for masoquista e quiser instalar uma versão CPU-only: `pip install 1.6.0+cpu`

3. Para salvar esse repositório no seu `requirements.txt`, basta adicionar como primeira linha:

```shell
-f https://download.pytorch.org/whl/torch_stable.html

...
torch==1.6.0+cu110
...
```

Happy torching!
