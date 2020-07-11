# Caster/Kaldi Speech Recognition Toolchain

## Use

### Application container

The application container requires:

1. an environment variable called `CASTER_USER_DIR` that points to your personal Caster user directory (the one that contains your rules and settings, not the source code directory), and
2. a [PulseAudio socket](https://github.com/mviereck/x11docker/wiki/Container-sound:-ALSA-or-Pulseaudio#pulseaudio-with-shared-socket) on the host machine located at `/run/user/${UID}/pulse/native`, where `${UID}` is your user ID given by the command `id -u`

To build the application container:

```console
make build
```

Launch the container with the following command:

```console
make run
```

The container will mount [a Caster user directory](https://caster.readthedocs.io/en/latest/readthedocs/User_Dir/Caster_User_Dir/) that is stored on the host at the location given by the value of the environment variable `CASTER_USER_DIR`. Storing the user directory on the host allows you to easily modify rules, settings, etc. without having to rebuild the image.

Compiling the models takes time, so it is recommended to start and stop the same container so that the compiled models are persisted between sessions. To stop the container, use the command `make stop`. To restart the container, use the command `make start`.

#### Container restarts

You can have the Docker daemon bring up the application container after system restarts by running

```console
make daemon
```

### Development container

Run the following command to build the development container:

```console
make build-dev
```

You will need an environment variable `CASTER_SRC_DIR` that points to your Caster source code directory. In addition, you will need to install the caster pip requirements inside the container once it is running. To run the development container:

```console
make dev
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).
