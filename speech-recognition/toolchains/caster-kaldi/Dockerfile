FROM python:3.8-slim AS base

ARG PORTAUDIO_COMMIT=799a6834a58592eadc5712cba73b35956dc51579

RUN apt-get update \
 && apt-get install -y \
    git \
    unzip \
    wget

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
    x11-utils \
    xclip \
    xdotool

# Requirements to build libportaudio
RUN apt-get install -y \
    libasound-dev \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt
WORKDIR /opt

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

###################################################################################################
FROM base AS dev

RUN mkdir /opt/Caster
WORKDIR /opt

###################################################################################################
FROM base AS app-alsa

ARG CASTER_COMMIT=37bb1c9f04acd1fd9fe7e14196098412a500aec6
ARG DICTATION_MODE_COMMIT=29a6e7dda7c371cb4549286cdd62a00f00b1fec6
ARG KALDI_MODEL_URL=https://github.com/daanzu/kaldi-active-grammar/releases/download/v1.4.0/kaldi_model_daanzu_20200328_1ep-mediumlm.zip

RUN git clone https://github.com/dictation-toolbox/Caster.git \
 && cd Caster \
 && git reset --hard ${CASTER_COMMIT} \
 && pip install -r requirements-mac-linux.txt \
 && pip install dragonfly2[kaldi] \
 && cd ..

RUN wget -q -O kaldi.zip ${KALDI_MODEL_URL} \
 && unzip kaldi.zip -d /opt \
 && rm kaldi.zip

# Install tools for improving the use of dictation mode with the Kaldi engine
RUN git clone https://github.com/Danesprite/dictation-mode-grammar.git \
 && cd dictation-mode-grammar \
 && git reset --hard ${DICTATION_MODE_COMMIT} \
 && cp _dictation_mode.py text_dictation_formatting.py ../Caster \
 && cd .. \
 && rm -rf dictation-mode-grammar

# Grant full access to these directories because both Caster and Kaldi require that the user, which
# is known only at container runtime, is capable of writing files to multiple locations within
# these directories
RUN mkdir \
    /opt/appuser \
    /opt/kaldi_model.tmp \
 && chmod 777 -R \
    /opt/Caster \
    /opt/appuser \
    /opt/kaldi_model \
    /opt/kaldi_model.tmp

# Dragonfly requires that the HOME environment variable is set, but the container will be run as a
# user that lacks a HOME directory
ENV HOME=/opt/appuser

WORKDIR /opt/Caster
ENTRYPOINT [ "python", "-m", "dragonfly", "load", "_*.py", "--engine", "kaldi", "-o", "model_dir=/opt/kaldi_model,tmp_dir=/opt/kaldi_model.tmp", "--no-recobs-messages" ]

###################################################################################################
FROM app-alsa AS app-pulseaudio

RUN apt-get update \
 && apt-get install -y \
    pulseaudio \
 && rm -rf /var/lib/apt/lists/*

ENV HOME=/opt/appuser

WORKDIR /opt/Caster
ENTRYPOINT [ "python", "-m", "dragonfly", "load", "_*.py", "--engine", "kaldi", "-o", "model_dir=/opt/kaldi_model,tmp_dir=/opt/kaldi_model.tmp", "--no-recobs-messages" ]
