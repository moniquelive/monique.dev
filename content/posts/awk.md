---
title: Como interpretar uma lista de pares chave-valor com AWK
date: 2020-09-07T12:00:00-03:00
tags: [awk, parse, shell, oneliner]
#featuredImage: https://logodownload.org/wp-content/uploads/2017/11/gnu-logo.png
---

Um exemplo simples, usando `env` como entrada:

```bash
env | grep EDITOR
EDITOR=vim
```

```bash
env | awk -F= '{a[$1]=$2} END {print(a["EDITOR"])}'
vim
```

Entretanto, é muito mais fácil fazer `echo $EDITOR`.

Mas as vezes não é tão fácil:

```bash
xdotool getactivewindow getwindowgeometry --shell | awk -F= '{a[$1]=$2} END {print(a["WIDTH"])}'
1430
```

Caso queira pegar a largura da janela ativa.

_

= M =
