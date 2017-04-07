[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/Intelora/core) [![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)](https://github.com/Intelora/core) [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/Intelora/core) [![Build Status](https://travis-ci.org/Intelora/core.svg?branch=master)](https://travis-ci.org/Intelora/core)
==========
Intelora Intelligent Personal Assistant Platform
==========

Intelora is based on [Mycroft: An Open Source Artificial Intelligence for Everyone] (https://github.com/MycroftAI/mycroft-core).

See [WIKI](https://github.com/Intelora/core/wiki) for full documentation of this project.

Join the Intelora Slack Team by clicking this [LINK](https://intelora-slack-invite.herokuapp.com). Enter your email and click the link that will be sent to you.

## Build and Setup Intelora

### For Developers and Contributors

Clone the repository.

### For Normal Users

Download the latest [RELEASE](https://github.com/Intelora/core/archive/master.zip).

### Debian, Arch, Fedora or Solus Based Operating Systems

- Run the 'build_host_setup_*' script specific for your OS.
- Run `dev_setup.sh` to setup the virtual environment.

### Other Environments

The following packages are required for setting up the development environment, and are what is installed by `build_host_setup` scripts.

 - `git`
 - `python 2`
 - `python-setuptools`
 - `python-virtualenv`
 - `pygobject`
 - `virtualenvwrapper`
 - `libtool`
 - `libffi`
 - `openssl`
 - `autoconf`
 - `bison`
 - `swig`
 - `glib2.0`
 - `s3cmd`
 - `portaudio19`
 - `mpg123`
 - `flac`
 - `curl`

## Account Manager

Mycroft AI, Inc. maintains the API and Accounts Management System. Developers can sign up and manage their account at [https://home.mycroft.ai].

By default the Intelora software is configured to use Mycroft API, upon any request such as "Hey [NAME], what is the weather?", you will be informed that you need to pair and Intelora will speak a 6-digit code, which you enter into the pairing page on the [Mycroft API Site](https://home.mycroft.ai).

Once signed and a device is paired, the unit will use our API keys for services, such as the STT (Speech-to-Text) API. It also allows you to use our API keys for weather, Wolfram-Alpha, and various other skills.

Pairing information generated by registering with Home is stored in:

`~/.mycroft/identity/identity2.json` <b><-- DO NOT SHARE THIS WITH OTHERS!</b>

It's useful to know the location of the identity file when troubleshooting device pairing issues.

## Using Intelora without Mycroft API.

If you do not wish to use our service, you may insert your own API keys into the configuration files listed below in <b>configuration</b>.

The place to insert the API key looks like the following:

`[WeatherSkill]`

`api_key = ""`

Put the relevant key in between the quotes and Mycroft Core should begin to use the key immediately.

### API Key Services

- [STT API, Google STT](http://www.chromium.org/developers/how-tos/api-keys)
- [Weather Skill API, OpenWeatherMap](http://openweathermap.org/api)
- [Wolfram-Alpha Skill](http://products.wolframalpha.com/api/)

These are the keys currently in use in Intelora.

## Configuration

Configuration file can be found at mycroft/configuration/mycroft.conf

When the configuration loader starts, it looks in in that locations and loads ALL configuration. Keys that exist in multiple config files will be overridden by the last file to contain that config value. This results in a minimal amount of config being written for a specific device/user, without modifying the distribution files.

## Running Intelora Quick Start

To start the essential tasks run `./intelora.sh start`. Which will start the service, skills, voice and cli (using --quiet mode) in a detched screen and log the output of the screens to the their respective log files (e.g. ./log/mycroft-service.log).
Optionally you can run `./intelora.sh start -v` Which will start the service, skills and voice. Or `./intelora.sh start -c` Which will start the service, skills and cli.

To stop Intelora run `./intelora.sh stop`. This will quit all of the detached screens.
To restart Mycroft run './mycroft.sh restart`.

Quick screen tips
- run `screen -list` to see all running screens
- run `screen -r [screen-name]` (e.g. `screen -r intelora-service`) to reatach a screen
- to detach a running screen press `ctrl + a, ctrl + d`
See the screen man page for more details 

## Running Intelora Individual Services

### With `start.sh`

Intelora provides `start.sh` to run a large number of common tasks. This script uses the virtualenv created by `dev_setup.sh`. The usage statement lists all run targets, but to run a Intelora stack out of a git checkout, the following processes should be started:

- run `./start.sh service`
- run `./start.sh skills`
- run `./start.sh voice`

*Note: The above scripts are blocking, so each will need to be run in a separate terminal session.*

### Without `start.sh`

Activate your virtualenv.

With virtualenv-wrapper:
```
workon mycroft
```

Without virtualenv-wrapper:
```
source ~/.virtualenvs/mycroft/bin/activate
```
- run `PYTHONPATH=. python client/speech/main.py` # the main speech detection loop, which prints events to stdout and broadcasts them to a message bus
- run `PYTHONPATH=. python client/messagebus/service/main.py` # the main message bus, implemented via web sockets
- run `PYTHONPATH=. python client/skills/main.py` # main skills executable, loads all skills under skills dir

*Note: The above scripts are blocking, so each will need to be run in a separate terminal session. Each terminal session will require that the virtualenv be activated. There are very few reasons to use this method.*

## FAQ/Common Errors

#### When running, I get the error `mycroft.messagebus.client.ws - ERROR - Exception("Uncaught 'error' event.",)`

This means that you are not running the `./start.sh service` process. In order to fully run Mycroft, you must run `./start.sh service`, `./start.sh skills`, and `./start.sh voice`/`./start.sh cli` all at the same time. This can be done using different terminal windows, or by using the included `./mycroft.sh start`, which runs all four process using `screen`.
