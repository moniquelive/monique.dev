---
title: Auto ativar e desativar python venv usando zsh
date: 2021-12-21T12:00:00-03:00
tags: [python, venv, zsh, chpwd]
#featuredImage: https://logodownload.org/wp-content/uploads/2019/10/python-logo-1.png
---

Quando aprendi sobre o python venv (`apt-get install python3-venv`) me
converti na hora. É simples, padrão e explícito.

Agora toda vez que crio um projeto automaticamente executo
`python3 -mvenv venv && source ./venv/bin/activate`.

Mas digitar `./venv/bin/activate` e depois `deactivate` é muito trabalho para
meu cérebro preguiçoso de programadora.

Então decidi investir finalmente 10 minutos para me liberar de ficar
ativando e desativando esse negócio toda vez que eu entrasse ou saísse de uma
pasta de projeto com minha pastinha padrão `./venv`:

```zsh
#---------------------------------------------- chpwd pyvenv ---
python_venv() {
  MYVENV=./venv
  # when you cd into a folder that contains $MYVENV
  [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
  # when you cd into a folder that doesn't
  [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv

python_venv
```

Só colar isso no seu `~/.zshrc`

_

= M =
