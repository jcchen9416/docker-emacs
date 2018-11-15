ARG VERSION=18.04
FROM ubuntu:$VERSION

MAINTAINER jcchen9416 <jcchen9416@gmail.com>

ENV DEBIAN_FRONTEND noninteractive


# apt source; Use "http://mirrors.163.com" in China.
ARG APT_MIRROR=
RUN /bin/bash -c 'if [[ -n "$APT_MIRROR" ]]; then sed -i 's#http://archive.ubuntu.com#$APT_MIRROR#g' /etc/apt/sources.list; fi'


# timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# utf-8 ; zh_CN
RUN apt-get update && apt-get -y install locales
RUN locale-gen en_US.UTF-8 &&\
  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV LANG="en_US.UTF-8"


# fonts
RUN apt-get install -y language-pack-zh-hans \
    ttf-mscorefonts-installer \
    fontconfig
RUN mkdir /usr/share/fonts/win
ADD fonts/ /usr/share/fonts/win/
RUN cd /root && mkfontscale && mkfontdir && fc-cache -fv


# software
RUN apt-get -y install \
    emacs \
    markdown \
    dbus-x11 fcitx fcitx-rime librime-data-wubi


# xim(chinese input method)
ENV XMODIFIERS "@im=fcitx"
ENV GTK_IM_MODULE fcitx
ENV QT_IM_MODULE fcitx
ENV LC_CTYPE zh_CN.UTF-8


ARG HOME=/root


# rime
ADD rime/ $HOME/.config/fcitx/rime
ADD fcitx/profile $HOME/.config/fcitx/profile


# clean
RUN apt-get autoclean && apt-get autoremove

ENTRYPOINT ["bash", "-c", "fcitx; emacs; /bin/bash"]
