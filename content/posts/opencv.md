---
title: Como eu compilo o OpenCV no Linux com um monte de penduricalhos (CuDNN, CUDA, OpenGL, Qt, TrueType, CODECs de Video)
date: 2021-02-16T12:00:00-03:00
description: >-
  Detalho cada dependência e flag do meu cmake gigante para compilar o OpenCV com CUDA,
  CuDNN, Qt, OpenGL e companhia.
tags: [opencv, python, cuda]
images: [https://upload.wikimedia.org/wikipedia/commons/5/53/OpenCV_Logo_with_text.png]
---

## Resumo
Cada dependência e flag do meu cmake gigante para compilar o OpenCV com CUDA, CuDNN, Qt, OpenGL e companhia.

OpenCV é uma biblioteca gigante. Mas ao mesmo tempo bastante flexível. Você escolhe o que a sua versão vai ter através da instalação ou não no seu sistema de dependências opcionais.

Neste artigo vou mostrar como eu faço para compilar o OpenCV com a maior linha de comando de cmake que já escrevi. Vou também adicionar comentários para que você entenda o que é necessário para compilar com sucesso.

Vamos começar.

## Download

Você vai precisar de dois projetos para compilar o OpenCV: o código fonte do [OpenCV](https://github.com/opencv/opencv) e o OpenCV [contrib](https://github.com/opencv/opencv_contrib).

Você pode tanto baixar as últimas versões como .zip ou .tar.gz ou clonar os repositórios e fazer checkout das últimas versões.

Independente da forma que você escolheu baixar, extraia os projetos um ao lado do outro na mesma pasta:

![Pastas dos projetos OpenCV e OpenCV contrib lado a lado](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9j200ku8p9m40i4yci2p.png)

## Dependências

Se você instalar todas as dependências que eu apresentarei, você terá:

```console
--   OpenCV modules:
--     To be built:                 aruco bgsegm bioinspired calib3d ccalib core cudaarithm cudabgsegm cudacodec cudafeatures2d cudafilters cudaimgproc cudalegacy cudaobjdetect cudaoptflow cudastereo cudawarping cudev cvv datasets dnn dnn_objdetect dnn_superres dpm face features2d flann freetype fuzzy gapi hfs highgui img_hash imgcodecs imgproc intensity_transform line_descriptor mcc ml objdetect optflow phase_unwrapping photo plot python3 quality rapid reg rgbd saliency shape stereo stitching structured_light superres surface_matching text tracking video videoio videostab xfeatures2d ximgproc xobjdetect xphoto
--     Disabled:                    world
--     Disabled by dependency:      -
--     Unavailable:                 alphamat cnn_3dobj hdf java julia matlab ovis python2 sfm ts viz
```

Instale:

* `python3 + numpy` - Eu normalmente instalo o OpenCV globalmente, por fora de qualquer ambiente virtual (venv/virtualenv). Dessa forma é possível reutiliza-lo depois adicionando ele nos seus ambientes virtuais. Essa é a saída esperada do cmake:
![Configuração do Python 3 e NumPy encontrada pelo CMake](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/mkf4fj56cwg7joh5c0pj.png)
* `python3-pyqt5.qtopengl` - este pacote é o suficiente para instalar o Qt5 + OpenGL. Por que o OpenGL é tão importante? Pra ter um fps acelerado por hardware. Essa é a saída esperada do cmake:
![Suporte a Qt 5 e OpenGL encontrado pelo CMake](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ri1jx1v2xq8c6aahwfw3.png)
* `ffmpeg + gstreamer` - se precisa carregar videos em diferentes formatos (codecs):
![Suporte a FFmpeg e GStreamer encontrado pelo CMake](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/kv61j50z5xf9yp5zbuyy.png)
* `libfreetype-dev + libharfbuzz-dev` - para usar fontes TrueType (.ttf)
* `CUDA + CuDNN` - esses dois têm uma explicação a parte abaixo.

### CUDA + CuDNN

CUDA (e CuDNN) são normalmente instalados na mesma hierarquia de pastas. E a pasta raíz é tipicamente a `/usr/local/cuda-<versao>`. Mas não é uma obrigatoriedade. Eu uso o PopOS e ele instala na pasta `/usr/lib/cuda-<versao>`. Também é possível ter várias versões instaladas ao mesmo tempo:
![Versões do CUDA instaladas em paralelo](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/61phl56afoj4ziabwrry.png)

Como visto acima, apesar da versão CUDA-11.2 ter sido instalada automaticamente (essa é a versão atual hoje), o CuDNN só está disponível até a versão 11.1, então tive que instalar em paralelo a versão CUDA-11.1 para ter ambos na mesma hierarquia de pastas.

Pra fazer o cmake encontrar eles, basta ter a pasta `<raiz do CUDA/bin` no seu `$PATH`.

Verifique se está tudo ok:
![Verificação da instalação do CUDA e do CuDNN no terminal](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tdsyvs01m2wx9ad387an.png)

Ufa! Moleza né?! 🤣

Bora compilar esse negócio!

## Verificação das dependências

Pra poder compilar, você precisa criar uma sub-pasta `build` dentro da pasta do opencv (`cd opencv; mkdir build; cd build`).

Agora respira fundo e aprecia a maior linha de comando que já escrevi pra chamar um programa:

```bash
cmake -D CMAKE_CXX_COMPILER=/usr/bin/g++ \
-D CUDA_HOST_COMPILER:FILEPATH=/usr/bin/gcc-9 \
-D CUDA_NVCC_FLAGS=--expt-relaxed-constexpr \
-D WITH_CUDA=ON \
-D WITH_CUDNN=ON \
-D CUDNN_INCLUDE_DIR=/usr/lib/cuda-11.1/include \
-D OPENCV_DNN_CUDA=ON \
-D ENABLE_FAST_MATH=1 \
-D CUDA_FAST_MATH=1 \
-D CUDA_ARCH_BIN=8.6 \
-D WITH_CUBLAS=1 \
-D WITH_TBB=ON \
-D WITH_OPENMP=ON \
-D WITH_IPP=ON \
-D CMAKE_BUILD_TYPE=RELEASE \
-D WITH_CSTRIPES=ON \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
-D CMAKE_INSTALL_PREFIX=/usr/local/ \
-D WITH_QT=ON \
-D WITH_OPENGL=ON \
-D BUILD_EXAMPLES=OFF \
-D BUILD_DOCS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_opencv_python3=ON \
-D PYTHON3_EXECUTABLE=$(which python3) \
-D PYTHON_INCLUDE_DIR=$(python2 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
-D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
-D PYTHON3_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
-D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
-D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
..
```
Os dois `..` no final são importantes!

Explicando algumas configurações:
* `CMAKE_CXX_COMPILER` - para compilar arquivos c++
* `CUDA_HOST_COMPILER:FILEPATH` - para compilar arquivos cuda - Durante a instalação do pacote `system76-cudnn` reparei que ele instalva o `gcc-9`. Nada científico, eu sei.
* `CUDA_NVCC_FLAGS` - precisei um dia, posso parar de usar eventualmente
* `CUDNN_INCLUDE_DIR` - verifique sua pasta raiz do CUDA ai
* `CUDA_ARCH_BIN` - a arquitetura da sua GPU. Verifique aqui: https://developer.nvidia.com/cuda-gpus
* `OPENCV_EXTRA_MODULES_PATH` - caminho relativo ou absoluto da pasta raiz do projeto opencv_contrib

Pra validar se ele encontrou todas as dependências, compare a linha `Unavailable: ...` no inicio da sessão anterior e procure por diferenças com a sua.

Caso precise rodar o cmake novamente, saia da pasta `build`, apague ela, recrie, lembre de mudar pra ela e só então rode de novo o cmake. Não pule esta estapa!

## Compilar

Essa é a parte mais fácil de todas. Dado que todas as dependências foram encontradas, basa rodar o comando `make`:

```bash
make -j<number of processes>
```

Recomendo fortemente utilizar a flag `-j` para diminuir o tempo de compilação. Caso queira continuar usando seu computador enquanto compila, recomendo usar um valor de `$(nproc)-2`.

Para sua referência, usar `-j60` e um armazenamento nvme, levou mais um menos 5 minutos e meio aqui.

Se algo der errado e o processo parar antes dos 100%, role pra cima (ou procure por `error:`) e verifique o que aconteceu.

## Instalar

Se chegou até aqui:

![Compilação do OpenCV concluída com sucesso](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/8dmme6y95n7525ca9qf8.png)

💯% baby!

Só precisa agora de:

```bash
sudo make install
```

Essa é a única vez que precisamos evocar os super poderes do root, para poder copiar os arquivos para a pasta `/usr/local`.

## Validar

Para testar sua conquista:

```console
$ python3
>>> import cv2
>>> print(cv2.getBuildInformation())
```

Compare essa saída com a do cmake. Verifique as dependencias e a data. Se nao baterem, desinstale o pip `opencv-contrib-python`.

## Usar

Para usar o OpenCV em um venv (leia mais sobre venv's [aqui](/posts/opencv-autocomplete-pycharm/)) use as flags:

```bash
python -mvenv --system-site-packages venv
```

Isso vai criar uma sub-pasta chamda `venv` com um ambiente virtual que inclui os pacotes globais do sistema, como o OpenCV.

## Conclusão

Se você chegou até aqui, parabéns! Você é uma pessoa muito determinada 🤣

Se precisar de alguma ajuda, deixe um comentário abaixo.

Boa sorte!

_

= M =
