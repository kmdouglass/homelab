# Caster/Kaldi Speech Recognition Toolchain

## Use

### Application container

To build the application container:

```console
docker build -t caster .
```

Launch the container with the following command:

```console
docker run \
       -t \
       -e DISPLAY=$DISPLAY \
       -e XDG_SESSION_TYPE=$XDG_SESSION_TYPE \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v $CASTER_USER_DIR:/home/caster/.local/share/caster \
       --device /dev/snd \
       --group-add audio \
       --pid=host \
       --name caster \
       caster
```

The container will mount [a Caster user directory](https://caster.readthedocs.io/en/latest/readthedocs/User_Dir/Caster_User_Dir/) that is stored on the host at `$CASTER_USER_DIR`. This allows you to easily modify rules, settings, etc. without having to rebuild the image.

Compiling the models takes time, so it is recommended to start and stop the same container so that the compiled models are persisted between sessions. To stop the container, use the command `docker stop caster`. To restart the container, use the command `docker start caster`.

#### Arguments

- **-t** - Attach a TTY device so that print messages appear in the container logs
- **-e DISPLAY=$DISPLAY** - Share the environment variable that contains the current X11 display with the container
- **-e XDG_SESSION_TYPE=$XDG_SESSION_TYPE** - This environment variable is used by Dragonfly when determining which keyboard implementation to use
- **-v $CASTER_USER_DIR:/home/caster/.local/share/caster** - Mount the caster user directory from the host into the container
- **--device /dev/snd** - Add the `snd` device file to the container so that the container can access the sound card
- **--group-add audio** - Add the container's user to the host's audio group so that the container can access the microphone
- **--pid=host** - Use the host's PID namespace so that the process ID of the current window can be determined from the data returned by `xprop`
- **--name caster** - Assign the name `caster` to the container

#### Container restarts

You can have the docker daemon bring up the application container after system restarts by adding the `-d --restart always` arguments to the `docker run` command above.

### Development container

When developing in containers, I assign group ownership of the source code files to a group called `developers`. The source code files are mounted into a folder inside the container with the same group ownership. The GID of this group must be supplied as a build argument when building the development image. If it is not supplied, then a default value will be provided, but its GID cannot be guaranteed to match the GID on the host.

Run the following command to build the development container, replacing `$DEVELOPERS` with the name of a group that can be used to share permissions between your host and the container:

```console
docker build -t caster:dev --build-arg DEVELOPERS_GID=$(getent group $DEVELOPERS | cut -d: -f3) --target dev .
```

You will still need to mount the caster source code directory and install the caster pip requirements inside the container. In the below command, the environment variable `CASTER_SRC_DIR` refers to the full path of the caster source code directory *on the host* and the environment variable `DEVELOPERS` refers to the group on the host that has read and write access to the source code directory (as explained above).

```console
docker run \
       -it \
       -e DISPLAY=$DISPLAY \
       -e XDG_SESSION_TYPE=$XDG_SESSION_TYPE \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v $CASTER_SRC_DIR:/home/caster/Caster \
       --device /dev/snd \
       --group-add audio \
       --group-add $DEVELOPERS \
       --pid=host \
       --name caster-dev \
       caster:dev \
       bash
```

## Notes

### StartApp fails to find an application

Dragonfly's StartApp action searches the file system of the container for executables. It therefore cannot find executable files that are located on the host file system.


### Error when querying the microphone

The following error appears when lanuchingg dragonfly: `sounddevice.PortAudioError: Error querying device -1`:

```
Traceback (most recent call last):
  File "/usr/local/lib/python3.8/runpy.py", line 194, in _run_module_as_main
    return _run_code(code, main_globals, None,
  File "/usr/local/lib/python3.8/runpy.py", line 87, in _run_code
    exec(code, run_globals)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/__main__.py", line 409, in <module>
    main()
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/__main__.py", line 404, in main
    return_code = func(args)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/__main__.py", line 174, in cli_cmd_load
    with engine.connection():
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/engines/base/engine.py", line 50, in __enter__
    self._engine.connect()
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/engines/backend_kaldi/engine.py", line 157, in connect
    self._audio = VADAudio(aggressiveness=self._options['vad_aggressiveness'], start=False, input_device_index=self._options['input_device_index'])
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/engines/backend_kaldi/audio.py", line 198, in __init__
    super(VADAudio, self).__init__(**kwargs)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/engines/backend_kaldi/audio.py", line 59, in __init__
    self._connect(start=start)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/engines/backend_kaldi/audio.py", line 66, in _connect
    self.stream = sounddevice.RawInputStream(
  File "/home/caster/.local/lib/python3.8/site-packages/sounddevice.py", line 1152, in __init__
    _StreamBase.__init__(self, kind='input', wrap_callback='buffer',
  File "/home/caster/.local/lib/python3.8/site-packages/sounddevice.py", line 777, in __init__
    _get_stream_parameters(kind, device, channels, dtype, latency,
  File "/home/caster/.local/lib/python3.8/site-packages/sounddevice.py", line 2571, in _get_stream_parameters
    info = query_devices(device)
  File "/home/caster/.local/lib/python3.8/site-packages/sounddevice.py", line 569, in query_devices
    raise PortAudioError('Error querying device {0}'.format(device))
sounddevice.PortAudioError: Error querying device -1
```

#### Solution

The user inside the container must belong to the `audio` group. In addition, the GID of the audio group in the container must be the same as the GID of the audio group on the host. This is not a problem with a Ubuntu host and a Debian container because the GIDs are the same, but the user inside the container still needs to be added to the `audio` group. See https://github.com/jessfraz/dockerfiles/issues/85#issuecomment-247840773 for more information.

```console
$ docker run --group-add audio ...
```

### The container cannot play sound

I am not sure whether this is an important problem, but I am nevertheless documenting it here.

```console
$ aplay test.wav 
ALSA lib pcm_dmix.c:1108:(snd_pcm_dmix_open) unable to open slave
aplay: main:828: audio open error: Device or resource busy
```

### Missing libtk library

The following command

```console
$ python -m dragonfly load _*.py --engine kaldi  --no-recobs-messages
```

raises the following exception:

```
Traceback (most recent call last):
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/loader.py", line 65, in load
    exec(compile(contents, self._path, 'exec'), namespace)
  File "/home/caster/Caster/_caster.py", line 33, in <module>
    control.init_nexus(_content_loader)
  File "/home/caster/Caster/castervoice/lib/control.py", line 6, in init_nexus
    from castervoice.lib.ctrl.nexus import Nexus
  File "/home/caster/Caster/castervoice/lib/ctrl/nexus.py", line 10, in <module>
    from castervoice.lib.ctrl.mgr.validation.combo.non_empty_validator import RuleNonEmptyValidator
  File "/home/caster/Caster/castervoice/lib/ctrl/mgr/validation/combo/non_empty_validator.py", line 2, in <module>
    from castervoice.lib.merge.selfmod.selfmodrule import BaseSelfModifyingRule
  File "/home/caster/Caster/castervoice/lib/merge/selfmod/selfmodrule.py", line 8, in <module>
    from castervoice.lib.merge.state.actions2 import NullAction
  File "/home/caster/Caster/castervoice/lib/merge/state/actions2.py", line 3, in <module>
    from castervoice.asynch.hmc import h_launch
  File "/home/caster/Caster/castervoice/asynch/hmc/h_launch.py", line 9, in <module>
    from castervoice.asynch.hmc.hmc_ask_directory import HomunculusDirectory
  File "/home/caster/Caster/castervoice/asynch/hmc/hmc_ask_directory.py", line 6, in <module>
    from tkinter import Label, Entry, StringVar, filedialog as tkFileDialog
  File "/usr/local/lib/python3.8/tkinter/__init__.py", line 36, in <module>
    import _tkinter # If this fails your Python may not be configured for Tk
ImportError: libtk8.6.so: cannot open shared object file: No such file or directory
```

#### Solution

tk 8.6 needs to be present inside the container.

```
$ apt-get install tk
```

### Keyboard support is not implemented

```
Core: switch to most recent Windows
ERROR:action.exec:Execution of ['alt:down, tab/20:%(nnavi10)d, alt:up'] failed due to exception: Keyboard support is not implemented for this platform!
Traceback (most recent call last):
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_base.py", line 98, in execute
    if self._execute(data) is False:
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_base_keyboard.py", line 131, in _execute
    return super(BaseKeyboardAction, self)._execute(data)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_base.py", line 173, in _execute
    self._execute_events(events)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_key.py", line 513, in _execute_events
    self._keyboard.send_keyboard_events(events)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/keyboard/_base.py", line 36, in send_keyboard_events
    raise NotImplementedError("Keyboard support is not implemented for "
NotImplementedError: Keyboard support is not implemented for this platform!
Navigation: squat
ERROR:action.exec:Execution of <left:down> failed due to exception: Mouse button events are not implemented for this platform!
Traceback (most recent call last):
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_base.py", line 98, in execute
    if self._execute(data) is False:
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_base.py", line 154, in _execute
    self._execute_events(self._events)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_mouse.py", line 348, in _execute_events
    event.execute(window)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/mouse/_base.py", line 157, in execute
    raise NotImplementedError(message)
NotImplementedError: Mouse button events are not implemented for this platform!
```

#### Solution

Dragonfly checks for the environment variable `XDG_SESSION_TYPE` when determining which keyboard implementation to use. Pass it as an environment variable when starting the container:

```
docker run -e XDG_SESSION_TYPE=$XDG_SESSION_TYPE ...
```

### Assertion fails in the function PaAlsaStreamComponent_BeginPolling

The following exception is raised randomly during the main Caster event loop:

```
python: src/hostapi/alsa/pa_linux_alsa.c:3641: PaAlsaStreamComponent_BeginPolling: Assertion `ret == self->nfds' failed.
```

#### Solution

There is a known but unfixed bug in the PortAudio library. The solution requires patching the file `pa_linux_alsa.c`. See the following links for more information.

- https://stackoverflow.com/questions/59006083/how-to-install-portaudio-on-pi-properly
- https://app.assembla.com/spaces/portaudio/tickets/realtime_list?ticket=268
- https://lists.columbia.edu/pipermail/portaudio/2019-July/001888.html
- https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=944509

### Messages do not appear in the console

Some messages that normally come from the main Caster event loop, such as when a command is recognized, are not printed to the console.

#### Solution

Attach a TTY to the container by passing the `-t` flag to the `docker run` command.

```console
$ docker run -t ...
```

### The clipboard fails for some grammars

I received the following error when I tried to use the function command from the python grammar for the first time.

```console
Python: function
ERROR:action.exec:Execution of Store() failed due to exception: 
    Pyperclip could not find a copy/paste mechanism for your system.
    For more information, please visit https://pyperclip.readthedocs.io/en/latest/index.html#not-implemented-error 
Traceback (most recent call last):
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/actions/action_base.py", line 98, in execute
    if self._execute(data) is False:
  File "/home/caster/Caster/castervoice/lib/temporary.py", line 48, in _execute
    _, orig = context.read_selected_without_altering_clipboard(False)
  File "/home/caster/Caster/castervoice/lib/context.py", line 116, in read_selected_without_altering_clipboard
    cb = Clipboard(from_system=True)
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/util/clipboard.py", line 101, in __init__
    self.copy_from_system()
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/util/clipboard.py", line 121, in copy_from_system
    self._content = self.get_system_text()
  File "/home/caster/.local/lib/python3.8/site-packages/dragonfly/util/clipboard.py", line 68, in get_system_text
    return pyperclip.paste()
  File "/home/caster/.local/lib/python3.8/site-packages/pyperclip/__init__.py", line 640, in lazy_load_stub_paste
    return paste()
  File "/home/caster/.local/lib/python3.8/site-packages/pyperclip/__init__.py", line 303, in __call__
    raise PyperclipException(EXCEPT_MSG)
pyperclip.PyperclipException: 
    Pyperclip could not find a copy/paste mechanism for your system.
    For more information, please visit https://pyperclip.readthedocs.io/en/latest/index.html#not-implemented-error 
ERROR:action.exec:Execution failed: Store()+'def ():'+['left:3']+Retrieve()
```

#### Solution

Install the `xclip` runtime dependency of Pyperclip.

```console
$ apt-get install xclip
```
