
docker化emacs,拉下来可以直接使用(Windows/Linux/OSX). 支持中文输入法,集成fcitx.


Features
========

1. 支持中文及中文输入法
2. 集成了fcitx,fcitx-rime输入法
3. 支持集成 [vcxsrv.ahk](https://github.com/jcchen9416/vcxsrv-ahk ) 解决中文输入法切换快捷键冲突问题



Usage
=====

Windows
-------

1. 安装一个`X-Server`. e.g.

   - [VcXsrv](https://sourceforge.net/projects/vcxsrv/ ) 
   - [Xming](https://xming.en.softonic.com/ ) 
   - [Cygwin/x](https://x.cygwin.com/ )

我们以 `VcXsrv` 为例,安装成功后,启动 `X-Server`(XLaunch).

2. 设置环境变量

        export DISPLAY=<your-machine-ip>:0.0

3. 启动`docker-emacs`

        docker run --rm --name emacs \
         -e DISPLAY="$DISPLAY" \
         -v "<path_to_your_.emacs.d>:/root/.emacs.d" \
         jcchen/emacs:latest emacs

