---
title: Python3 + GTK+3 + Glade + Templates = <3
date: 2021-03-28T19:00:00-03:00
tags: [python, gtk, glade]
---

Vários softwares que você usa no ambiente Gnome podem ter sido desenvolvidos em Python. Aplicativos como Gnome Music e Gnome Tweaks são alguns exemplos disso.

Neste artigo eu vou mostrar um exemplo mínimo para que você tenha um ponto de partida para suas idéias. Vamos lá:

## Crie um layout básico usando o editor Glade:

![GtkApplicationWindow](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/suzcky8ibzokyhfcqv2q.png)

Coisas para prestar atenção:

- O componente raiz é um **GtkApplicationWindow** (aparece quando clica no botão _Toplevels_)
- Com ele selecionado, marque a checkbox _Composite_ lá na direita (super importante!)
- Quando você marca a checkbox _Composite_ o campo _ID_ vira _Class Name_. Dê um nome e guarde ele, pois vamos usar já já.
- Dê um _ID_ para o botão e guarde ele, pois vamos usar já já.

Com o Botão selecionado, troque para a aba _Signals_:

![Button Signals](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2p580mbgbc817xaaufe7.png)

- Clique na coluna _Handler_ da linha _clicked_
- Digite a primeira letra do nome do seu botão
- Aceite a sugestão (_btnMain_clicked_cb_, no meu examplo) e guarde ela, pois vamos usar já já.

Isso é tudo com o editor Glade. Salve seu _.glade_ na pasta do seu projeto.

## Crie um arquivo mínimo em Python:

```python
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import GLib, Gio, Gtk

import sys


#
# 1. nosso arquivo .glade (pode ter o path que quiser)
#
@Gtk.Template.from_file("a.glade")
class AppWindow(Gtk.ApplicationWindow):
    #
    # 2. a 'Class Name' de GtkApplicationWindow
    #
    __gtype_name__ = "app_window"

    #
    # 3. o 'ID' do Botão
    #
    btnMain: Gtk.Button = Gtk.Template.Child()

    #
    # 4. o nome do 'Handler' de 'Signals'
    #
    @Gtk.Template.Callback()
    def btnMain_clicked_cb(self, widget, **_kwargs):
        assert self.btnMain == widget
        print(widget.get_label())


class Application(Gtk.Application):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, application_id="dev.monique.Gtk1",
                         flags=Gio.ApplicationFlags.FLAGS_NONE, **kwargs)
        self.window = None

    def do_activate(self):
        self.window = self.window or AppWindow(application=self)
        self.window.present()


if __name__ == '__main__':
    Application().run(sys.argv)
```

Você também vai precisar:

```shell
pip install PyGObject
```

Pode ser que reclame de bibliotecas faltantes, basta ler a saída de erro e instalar as dependências (eu tive que `apt install libcairo2-dev libgirepository1.0-dev`)

Com este código você terá tudo que precisa para começar.

Boa Sorte!
