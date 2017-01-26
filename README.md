# docker-arma3server

This is a Docker-Image for ArmA 3 Server based on Ubuntu 16.04, using the full image approach.
This means the image contains the whole game files for the fastest possible boot-up time.
For smaller images with on-demand download check our [Registry](https://docker.play-net.org).

## Features

* Full Size game
* Defining basic game settings (being expanded over time)
* Exposing mods, keys, config and missions folder for volume mounting

## Variables

* SERVER_PORT
* SERVER_NAME
* SERVER_PASSWORD
* SERVER_ADMIN_PASSWORD
* SLOTS

Mod Preferences:

This image allows modding your server. Please note that the volume exposed to the host links to the 'mods' folder.
As a result, your mod strings have to prepend 'mods/' to all mods.
Look into the example for more help.

* MODS (for example: 'mods/@tfr;mods/@ace;mods/playnet')
* SERVER_MODS
* VERIFY_SIGNATURES

Mission Preferences:

* MISSION_NAME (optional to set mission autostart)
* MISSION_DIFFICULTY (defaults to regular)
* SERVER_PERSISTENT

## Ports
* 2302 (Game Port)
* 2303 (Steam Query)
* 2304 (Steam Port)

## Build container
To build this container you require a steam account with ArmA 3 in it's library.
As this is our full-package image, the steam credentials are already required at build time which makes it 
insecure to share on public image registries.

```bash
docker build --build-arg USERNAME=steamuser --build-arg PASSWORD=somesafepassword .                                                        
```

## Getting started

Run ArmA 3 Server with default settings:

```bash
docker run -tid -p 2302:2302 playnet/arma3server:latest
```

Run ArmA 3 Server with default settings, 20 Slots, 4GB Memory and all mounted volumes:

```bash
docker run -tid \
    -m 4096M \
    -p 2302:2302 \
    -e SLOTS=20 \
    -v missions:/opt/arma3/mpmissions \
    -v mods:/opt/arma3/mods \
    -v keys:/opt/arma3/keys \
    -v config:/opt/arma3/config \
    playnet/arma3server:latest
```
