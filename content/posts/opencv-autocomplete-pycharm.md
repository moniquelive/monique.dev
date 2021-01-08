---
title: Autocompletion globally installed OpenCV with PyCharm
date: 2021-01-08T17:24:33-03:00
tags: [python, opencv, pycharm]
cover_image: https://pyimagesearch.com/wp-content/uploads/2015/03/pycharm_opencv_logos.jpg
---

## Intro

For a long time I was a user of the [virtualenv](https://virtualenv.pypa.io/en/latest/) module. But ever since I learned about the standard module [venv](https://docs.python.org/3/tutorial/venv.html) I became a devotee.

For starters it comes bundled with python (or by installing the `python3-venv` package). It's also more predictable than virtualenv since you don't need to mess with your `.{bash/zsh/fish}rc` files and it's generally installed under your project's root dir.

But there's one exception for using locally installed packages, and it's packages that need to be built on your machine. OpenCV is one of them. You can install a pre-built one using `pip install opencv-python-contrib` but it won't take advantage of your shiny new GPU.

## OpenCV

Building OpenCV is a whole topic on itself but assuming you did all the steps (`cmake + infinite flags / sudo make install`) it'll be installed on your machine globally (on `/usr/lib`).

To use it locally on a `venv` isolated environment, you have to use the following flag:

```shell
python -mvenv --system-site-packages venv
```

The `--system-site-packages` flag creates a local environment but includes all the globally installed modules.

Just for completion sake, don't forget to active the environment:

```shell
source venv/bin/activate
```

## PyCharm

Now if you use PyCharm and would love to see the autocompletion work with your just installed OpenCV there's one extra step.

First of all, tell PyCharm to use your venv by going to `Settings -> Python Interpreter -> "cog" button -> Add -> Existing environment`.

_(If you create your venv first and then open the directory on PyCharm, it'll autodetect it)_

But by default PyCharm won't find the `.so` built for OpenCV. You have to tell it where it is.

To find where yours was installed you can use the `find` tool:

```shell
find /usr -name cv2\*so
```

Mine was found under `/usr/lib/python3/dist-packages/cv2/python-3.8/cv2.cpython-38-x86_64-linux-gnu.so`

Now you get back to the interpreter settings (`Settings -> Python Interpreter -> "cog" button -> Show all`), select the interpreter for your project, click on the toolbar's last button (`Show paths for the selected interpreter`) and add the above directory removing your `*.so` file name:

![Show paths for the selected interpreter](https://dev-to-uploads.s3.amazonaws.com/i/rkajktmxuejw9ur1hx0e.png)

After this last extra step autocomplete should work like a charm (oops...).

Happy coding!
