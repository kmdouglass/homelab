FROM python:3.8-slim AS base

ARG PORTAUDIO_COMMIT=799a6834a58592eadc5712cba73b35956dc51579

RUN apt-get update \
 && apt-get install -y \
    git \
    unzip \
    wget

# Requirements to build libportaudio
RUN apt-get install -y \
    libasound-dev

# Requirements to build wxpython
# https://github.com/wxWidgets/Phoenix/blob/master/README.rst#prerequisites
RUN apt-get install -y \
    build-essential \
    dpkg-dev \
    freeglut3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgstreamer-plugins-base1.0-dev \
    libgtk-3-dev \
    libjpeg-dev \
    libnotify-dev \
    libpng-dev \
    libsdl2-dev \
    libsm-dev \
    libtiff-dev \
    libwebkit2gtk-4.0-dev \
    libxtst-dev

# Caster runtime requirements
RUN apt-get install -y \
    tk \
    xclip \
    xdotool \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash caster
WORKDIR /home/caster

# Build and install libportaudio
COPY pa_linux_alsa.c.patch .
RUN git clone https://git.assembla.com/portaudio.git \
 && cd portaudio \
 && git reset --hard ${PORTAUDIO_COMMIT} \
 && patch src/hostapi/alsa/pa_linux_alsa.c < ../pa_linux_alsa.c.patch \
 && ./configure \
 && make \
 && make install \
 && ldconfig \
 && cd .. \
 && rm -rf portaudio pa_linux_alsa.c.patch

FROM base AS dev

ARG DEVELOPERS_GID=1001

RUN addgroup --gid ${DEVELOPERS_GID} developers \
 && mkdir /home/caster/Caster \
 && chgrp -R developers /home/caster/Caster

USER caster
WORKDIR /home/caster/Caster

FROM base AS app

ARG CASTER_COMMIT=bd1f07cb04a3f288a597a8aed7f784ab99eba7fc
ARG KALDI_MODEL_URL=https://github.com/daanzu/kaldi-active-grammar/releases/download/v1.4.0/kaldi_model_daanzu_20200328_1ep-mediumlm.zip

USER caster

RUN git clone https://github.com/dictation-toolbox/Caster.git \
 && cd Caster \
 && git reset --hard ${CASTER_COMMIT} \
 && pip install --user -r requirements-mac-linux.txt \
 && pip install --user dragonfly2[kaldi]

RUN wget -q -O kaldi.zip ${KALDI_MODEL_URL} \
 && unzip kaldi.zip -d Caster \
 && rm kaldi.zip

WORKDIR /home/caster/Caster
ENTRYPOINT [ "python", "-m", "dragonfly", "load", "_*.py", "--engine", "kaldi", "--no-recobs-messages" ]
