---
title: OBS Studio as a Virtual Webcam
date: 2021-01-08T17:23:30-03:00
tags: [obs,virtual cam,linux]
cover_image: https://obsproject.com/assets/images/new_icon_small-r.png
---

In the year 2020 video conferencing exploded worldwide. It became a necessity for many (now) remote workers.

If you happen to be a lucky (debian-based) Linux user, this set of steps will show you how to use OBS Studio as a video source in any conferencing software (Google Meet, Zoom.us, Discord, etc.). Here we go:

## Install OBS, libOBS, v4l loopback, qt-dev

```shell
sudo apt-get install obs-studio libobs-dev v4l2loopback-dkms qtbase5-dev
```

## Configure the kernel module (v4l2loopback)

```shell
sudo echo v4l2loopback > /etc/modules-load.d/v4l2loopback.conf
sudo echo 'options v4l2loopback card_label="OBS Video Source" video_nr=10 exclusive_caps=1' > /etc/modprobe.d/v4l2-obs-studio.conf
sudo depmod -a
sudo modprobe v4l2loopback
```

Parameters:
- `video_nr` device number that will be created `/dev/video10`
- `card_label` camera name that will show up on Meet/Zoom/Discord/etc
- `exclusive_caps` to work with Google Chrome


## Install the OBS plugin (v4l2sink)

```shell
git clone --recursive https://github.com/obsproject/obs-studio.git # OBS
git clone git@github.com:CatxFish/obs-v4l2sink.git # Plugin

cd obs-v4l2sink
mkdir build ; cd build
cmake -DLIBOBS_INCLUDE_DIR="../../obs-studio/libobs" -DCMAKE_INSTALL_PREFIX=/usr ..
make -j
sudo make install
```


_(edit: I just found out how to install plugins on your home dir instead of messing around your system's filesystem)_

It'll be installed in `/usr/lib/obs-plugins`, but let's install it on our home directory:

```shell
mkdir -p ~/.config/obs-studio/plugins/v4l2sink/{data,bin/64bit}
ln -sf /usr/lib/obs-plugins/v4l2sink.so ~/.config/obs-studio/plugins/v4l2sink/bin/64bit/
ln -sf /usr/share/obs-plugins/v4l2sink/locale ~/.config/obs-studio/plugins/v4l2sink/data/
```

If all worked, on the `Tools` menu there'll be an item `V4L2 Video Output`.
Set the device to `/dev/video10`, the video format to `YUY2`. Click on `Auto-Start`, `Start` and create a scene...

Happy conferencing!

