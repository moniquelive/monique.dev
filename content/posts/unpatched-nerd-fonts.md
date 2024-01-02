---
title: Usando símbolos de Nerdfont e Emoji com qualquer fonte (original) no Linux
date: 2024-01-03T12:00:00-03:00
descrição:
tags: [fontconfig, nerdfont, símbolos, fontfamily]
#featuredImage: https://dev-to-uploads.s3.amazonaws.com/uploads/articles/316326l50vp8do2bhun3.png
---

Depois de ler [a nota sobre esta questão](https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font) no FAQ do terminal Kitty, comecei a prestar atenção em editores, IDEs e terminais que suportam _fontes de fallback_.

_Uma fonte de fallback é uma tipografia alternativa contendo símbolos para o maior número possível de caracteres Unicode. Quando um sistema de exibição encontra um caractere que não faz parte do repertório de nenhuma das outras fontes disponíveis, um símbolo de uma fonte de fallback é usado em seu lugar. Tipicamente, uma fonte de fallback conterá símbolos representativos dos vários tipos de caracteres Unicode._ [^1]

Mas nem todos os editores, IDEs ou terminais suportam fontes de fallback. Como o emulador de terminal [alacritty](https://github.com/alacritty/alacritty/issues/957), por exemplo.

No entanto, o pacote [fontconfig](https://www.fontconfig.org/) do Linux é muito completo e permite criar famílias de fontes, que entendi serem fontes virtuais que você cria para ter o mecanismo de fallback configurado manualmente.

Então, vamos direto ao ponto! Primeiro crie um arquivo em `~/.config/fontconfig` chamado `fonts.conf` com o seguinte conteúdo:

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <match target="font">
    <edit name="autohint" mode="assign">
      <bool>true</bool>
    </edit>
  </match>
  <alias>
    <family>my-chosen-font-family</family>
    <prefer>
      <family>JetBrains Mono</family>
      <family>Symbols Nerd Font</family>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
</fontconfig>
```

A tag `<match>` solicita [auto-hinting](https://en.wikipedia.org/wiki/Font_hinting) para ter fontes com melhor aparência.

A tag `<alias>` contém o nome da sua fonte virtual `my-chosen-font-family` e o conjunto de fontes que pertencem a ela. No meu caso, tenho [uma fonte original (não modificada)](https://www.jetbrains.com/lp/mono/), a [symbols nerd font](https://www.nerdfonts.com/font-downloads) e a de [emoji](https://github.com/googlefonts/noto-emoji).

Agora tudo o que você precisa fazer é configurar seus aplicativos para usá-la. Em [alacritty](https://alacritty.org/) seria:

```yml
font:
  normal:
    family: my-chosen-font-family
    style: Regular

  bold:
    family: my-chosen-font-family
    style: Bold

  italic:
    family: my-chosen-font-family
    style: Italic

  bold_italic:
    family: my-chosen-font-family
    style: Bold Italic
```

Aproveite!

_

= M =

[^1]: https://en.wikipedia.org/wiki/Fallback_font
