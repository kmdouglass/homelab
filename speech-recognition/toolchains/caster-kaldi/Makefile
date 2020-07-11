CONTAINER_NAME=caster
IMAGE_NAME=caster

build: Dockerfile
	docker build -t caster .

build-dev: Dockerfile
	docker build -t caster:dev --build-arg --target dev .

daemon: build
	echo "Running the caster container as a daemon..."
	@docker run \
        -t \
       -e DISPLAY=${DISPLAY} \
       -e XDG_SESSION_TYPE=${XDG_SESSION_TYPE} \
       -e PULSE_SERVER=unix:/tmp/pulseaudio.socket \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /run/user/$$(id -u)/pulse/native:/tmp/pulseaudio.socket \
       -v ${CASTER_USER_DIR}:/opt/appuser/.local/share/caster \
       --device /dev/snd \
       --group-add audio \
       --pid=host \
       --user $$(id -u):$$(id -g) \
       --name $(CONTAINER_NAME) \
       -d \
       --restart always \
       $(IMAGE_NAME)

dev: build-dev
	docker run \
       -it \
       -e DISPLAY=$DISPLAY \
       -e XDG_SESSION_TYPE=$XDG_SESSION_TYPE \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /run/user/$$(id -u)/pulse/native:/tmp/pulseaudio.socket \
       -v ${CASTER_SRC_DIR}:/opt/appuser/.local/share/caster \
       --device /dev/snd \
       --group-add audio \
       --pid=host \
       --user $(id -u):$(id -g) \
       --name caster-dev \
       caster:dev \
       bash

run: build
	echo "Running the caster container..."
	@docker run \
        -t \
       -e DISPLAY=${DISPLAY} \
       -e XDG_SESSION_TYPE=${XDG_SESSION_TYPE} \
       -e PULSE_SERVER=unix:/tmp/pulseaudio.socket \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /run/user/$$(id -u)/pulse/native:/tmp/pulseaudio.socket \
       -v ${CASTER_USER_DIR}:/opt/appuser/.local/share/caster \
       --device /dev/snd \
       --group-add audio \
       --pid=host \
       --user $$(id -u):$$(id -g) \
       --name $(CONTAINER_NAME) \
       $(IMAGE_NAME)

start:
	@docker start $(CONTAINER_NAME)

stop:
	@docker stop $(CONTAINER_NAME)

.PHONY: build build-dev daemon run start stop
