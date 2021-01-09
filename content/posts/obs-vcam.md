---
title: OBS Studio como uma webcam virtual
date: 2020-12-22T12:00:00-03:00
tags: [obs,virtual cam,linux]
cover_image: https://obsproject.com/assets/images/new_icon_small-r.png
---

No ano de 2020 as video conferências explodiram pelo globo. Se tornaram uma necessidade para vários trabalhadores remotos.

Se você tiver a sorte de usar Linux (baseado em Debian), esse passo-a-passo vai te mostrar como usar o OBS Studio como uma fonte de vídeo em qualquer programa de conferência (Google Meet, Zoom, Discord, etc). Vamos lá:

## Instalar OBS, libOBS, v4l loopback, qt-dev

```shell
sudo apt-get install obs-studio libobs-dev v4l2loopback-dkms qtbase5-dev
```

## Configurar o módulo de kernel `v4l2loopback`

```shell
sudo echo v4l2loopback > /etc/modules-load.d/v4l2loopback.conf
sudo echo 'options v4l2loopback card_label="OBS Video Source" video_nr=10 exclusive_caps=1' > /etc/modprobe.d/v4l2-obs-studio.conf
sudo depmod -a
sudo modprobe v4l2loopback
```

Parâmetros:
- `video_nr` número do dispositivo que será criado `/dev/video10`
- `card_label` nome da câmera virtual que vai aparecer no Meet/Zoom/Discord/etc
- `exclusive_caps` pra funcionar com o Google Chrome 🤷


## Instalar o plugin de OBS `v4l2sink`

```shell
git clone --recursive https://github.com/obsproject/obs-studio.git # OBS
git clone git@github.com:CatxFish/obs-v4l2sink.git # Plugin

cd obs-v4l2sink
mkdir build ; cd build
cmake -DLIBOBS_INCLUDE_DIR="../../obs-studio/libobs" -DCMAKE_INSTALL_PREFIX=/usr ..
make -j
sudo make install
```


O plugin vai ser instalado em `/usr/lib/obs-plugins`, mas vamos colocar na nossa pasta home:

```shell
mkdir -p ~/.config/obs-studio/plugins/v4l2sink/{data,bin/64bit}
ln -sf /usr/lib/obs-plugins/v4l2sink.so ~/.config/obs-studio/plugins/v4l2sink/bin/64bit/
ln -sf /usr/share/obs-plugins/v4l2sink/locale ~/.config/obs-studio/plugins/v4l2sink/data/
```

Caso tenha funcionado, vai no menu `Tools`. Vai ter a opção `V4L2 Video Output`. Defina o dispositivo (device) como `/dev/video10`, o formato para `YUY2`, clique em `Auto-Start` e em `Start`. Aí é só criar uma cena no seu OBS e abrir sua câmera em outro programa!

Boas conferências ;)


_

= M =

