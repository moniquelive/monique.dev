---
title: How to parse a key-value pair list with AWK
date: 2021-01-08T12:00:00-03:00
tags: [awk, parse, shell, oneliner]
cover_image: https://logodownload.org/wp-content/uploads/2017/11/gnu-logo.png
---

A simple example, using env as input:

```bash
$ env | grep EDITOR
EDITOR=vim
```

```bash
$ env | awk -F= '{a[$1]=$2} END {print(a["EDITOR"])}'
vim
```

It's way easier to just do `echo $EDITOR` though.

But sometimes it's not so easy:

```bash
$ xdotool getactivewindow getwindowgeometry --shell | awk -F= '{a[$1]=$2} END {print(a["WIDTH"])}'
1430
```

If you want to get the current window's width.

_

= M =
