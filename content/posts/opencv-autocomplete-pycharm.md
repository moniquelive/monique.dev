---
title: OpenCV instalado globalmente com autocomplete no PyCharm
date: 2020-12-28T12:00:00-03:00
description: Ensino a combinar um venv com --system-site-packages e apontar o PyCharm pro .so do OpenCV para ganhar autocomplete cheio.
tags: [python, opencv, pycharm]
cover_image: https://pyimagesearch.com/wp-content/uploads/2015/03/pycharm_opencv_logos.jpg
---

## Resumo
Como combinar um venv com `--system-site-packages` e apontar o PyCharm pro `.so` do OpenCV para ganhar autocomplete completo.

## Intro

Por um bom tempo utilizei o módulo [virtualenv][virtual-env]. Mas desde que aprendi sobre o módulo padrão de python [venv][venv] nunca mais voltei.

Pra começar ele já vem instalado com o python (se não veio, basta instalar o pacote `python3-venv`). Ele também é mais previsível do que o `virtualenv`, já que não é necessário mexer nos seus arquivos de login `.{bash/zsh/fish}rc` e o uso padrão é instalá-lo na raíz do seu projeto.

Mas esse isolamento tem uma excessão, que são os módulos que precisam ser compilados na sua máquina. O `OpenCV` é um deles. Você pode usar o pacote pronto `opencv-python-contrib` mas não vai tirar vantagem da sua GPU reluzente, por exemplo.

## OpenCV

Compilar o `OpenCV` é um assunto para um post futuro, mas assumindo que você fez todos os passos (`cmake + flags infinitas / sudo make install`) ele vai se instalar em `/usr/lib`.

Para usar localmente em um ambiente `venv` isolado você deve criar o ambiente com essa flag:

```shell
python -mvenv --system-site-packages venv
```

A flag `--system-site-packages` cria um ambiente local mas inclui todos os módulos instalados globalmente.

Não se equeça de ativar seu ambiente:

```shell
source venv/bin/activate
```

## PyCharm

Agora, se você usa o PyCharm e adoraria ter autocomplete funcionando com o seu OpenCV, falta dar mais um passo.

Primeiro, diga ao PyCharm para usar seu `venv`, indo em `Settings -> Python Interpreter -> botão de engrenagem -> Add -> Existing environment`.

_(Se seu ambiente já existir antes de abrir o PyCharm, ele vai detectar sozinho)_

Mas o PyCharm não vai encontrar o arquivo `.so` criado pelo OpenCV. Você precisa mostrar aonde ele está.

Para encontrar aonde o seu está você pode usar a ferramenta `find`:

```shell
find /usr -name cv2\*so
```

O meu estava em `/usr/lib/python3/dist-packages/cv2/python-3.8/cv2.cpython-38-x86_64-linux-gnu.so`, por exemplo.

Agora volte nas configurações do PyCharm (`Settings -> Python Interpreter -> botão de engrenagem -> Show all`), selecione o interpretador do seu projeto, clica no último botão da barra de ferramentas (`Show paths for the selected interpreter`) e adiciona o diretório, removendo o nome do arquivo `*.so`:

![Show paths for the selected interpreter](https://dev-to-uploads.s3.amazonaws.com/i/rkajktmxuejw9ur1hx0e.png)

Depois deste último passo, o autocomplete vai funcionar perfeito!

Happy coding!

[virtual-env]: https://virtualenv.pypa.io/en/latest/ "Virtual Env"
[venv]: https://docs.python.org/3/tutorial/venv.html "venv"
