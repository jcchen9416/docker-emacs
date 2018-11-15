
Dockerized emacs with GUI on Windows/Linux/OSX. Integrated `fcitx` to support Chinese input method.

[中文版?](./README_zh_CN.md ) 



Features
========

1. Chinese / Chinese input method is supported
2. Integrated `fcitx` & `fcitx-rime` input method
3. Input method switching shortcuts conflict can be solve by [vcxsrv.ahk](https://github.com/jcchen9416/vcxsrv-ahk )


Usage
=====

Windows
-------

1. Install `X-Server` on Windows. e.g.

   - [VcXsrv](https://sourceforge.net/projects/vcxsrv/ ) 
   - [Xming](https://xming.en.softonic.com/ ) 
   - [Cygwin/x](https://x.cygwin.com/ )

    After successful installation, launch the `X-Server` (XLaunch).

2. Setting enviroment variables

        export DISPLAY=<your-machine-ip>:0.0

3. Launch `docker-emacs`

        docker run --rm --name emacs \
         -e DISPLAY="$DISPLAY" \
         -v "<path_to_your_.emacs.d>:/root/.emacs.d" \
         jcchen/emacs:latest emacs
    
