ARG VERSION=18.04
FROM ubuntu:$VERSION

MAINTAINER jcchen9416 <jcchen9416@gmail.com>

ENV DEBIAN_FRONTEND noninteractive


# apt source; Use "http://mirrors.163.com" in China.
ARG APT_MIRROR=
RUN /bin/bash -c 'if [[ -n "$APT_MIRROR" ]]; then sed -i 's#http://archive.ubuntu.com#$APT_MIRROR#g' /etc/apt/sources.list; fi'



# utf-8 ; zh_CN
RUN apt-get update --fix-missing && apt-get -y install locales tzdata
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


# timezone
ENV TZ=Asia/Shanghai
RUN rm /etc/localtime
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata


# Build emacs (with dependencies)
RUN apt-get install -y autoconf git
RUN apt-get install -y texinfo libgtk-3-dev libwebkit2gtk-4.0-dev \
    libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev librsvg2-dev imagemagick libgnutls28-dev \
    libncurses5-dev
RUN cd /opt \
    && git clone -b emacs-26 --depth 1 https://github.com/emacs-mirror/emacs.git emacs-26 \
    && cd emacs-26 \
    && ./autogen.sh all \
    && ./configure --prefix=/opt/emacs-26 --with-cairo --with-xwidgets --with-x --with-x-toolkit=gtk3 --with-modules --with-mailutils \
    && make \
    && make install

# "gap between BSS and heap" problem. 
#
#      echo 0 > /proc/sys/kernel/randomize_va_space
#      make
#      echo 2 > /proc/sys/kernel/randomize_va_space
#
# Refer to: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=23529




# software
RUN apt-get -y install \
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

ENTRYPOINT ["bash", "-c", "fcitx &; sleep 1; exec \"$@\""]

CMD ["/bin/bash"]
