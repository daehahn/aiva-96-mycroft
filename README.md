# Mycroft Core using AiVA-96 & DragonBoard 410c

The **WizeIoT’s AiVA mezzanine board for DragonBoard and 96Boards** enables developers of the smart home devices such as smart speaker, smart panels, kitchen equipment and other commercial and industrial electronics products to evaluate and prototype far-field hands-free voice interface using Amazon Alexa, Google Assistant, Microsoft Cortana voice service.

Built around XMOS XVF3000 voice processor with direct interfacing to a line array of four digital microphones, the AiVA board is an ideal platform for developers who want to integrate AI speaker into their products.

Mycroft is an open source voice assistant that can be extended and expanded to the limits of your imagination. 

This project provides a step-by-step walkthrough to help you build a hands-free Mycroft core prototype in 60 minutes, using wake word engines from **[CMU Sphnix](https://cmusphinx.github.io/)**. Now, instead of pushing a button to "start listening", you can now just say the wake word "Hey Mycroft", much like other AI assistants.

To find out more, visit: https://www.wizeiot.com/aiva-96/ home page and: https://mycroft.ai/get-mycroft/

This repository provides a simple-to-use automated script to install the [Mycroft core](https://github.com/MycroftAI/mycroft-core) on a [DragonBoard 410c](https://developer.qualcomm.com/hardware/dragonboard-410c) and configure the Dragon Board 410c to use the AiVA-96 for AVS for audio.


Mycroft [![Build Status](https://travis-ci.org/MycroftAI/mycroft-core.svg?branch=master)](https://travis-ci.org/MycroftAI/mycroft-core) [![Coverage Status](https://coveralls.io/repos/github/MycroftAI/mycroft-core/badge.svg?branch=dev)](https://coveralls.io/github/MycroftAI/mycroft-core?branch=dev)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
==========

Mycroft is a hackable open source voice assistant.

# Table of Contents

- [Table of Contents](#table-of-contents)
- [Prerequisites](#Prerequisites)
- [Getting Started](#getting-started)
- [Running Mycroft](#running-mycroft)
- [Using Mycroft](#using-mycroft)
  * [*Home* Device and Account Manager](#home-device-and-account-manager)
  * [Skills](#skills)
- [Behind the scenes](#behind-the-scenes)
  * [Pairing Information](#pairing-information)
  * [Configuration](#configuration)
  * [Using Mycroft Without Home](#using-mycroft-without-home)
  * [API Key Services](#api-key-services)
  * [Using Mycroft behind a proxy](#using-mycroft-behind-a-proxy)
    + [Using Mycroft behind a proxy without authentication](#using-mycroft-behind-a-proxy-without-authentication)
    + [Using Mycroft behind an authenticated proxy](#using-mycroft-behind-an-authenticated-proxy)
- [Getting Involved](#getting-involved)
- [Links](#links)


# Prerequisites
You will need:
---

- [AiVA-96 board](https://www.wizeiot.com/aiva-96/)
- [DragonBoard 410c](https://www.96boards.org/product/dragonboard410c/) or [compatible 96Boards](https://www.96boards.org/products/)
- [96Boards Compliant Power Supply](http://www.96boards.org/product/power/)
- MicroSD card (min. 16GB)
- Monitor with HDMI input, HDMI cable
- USB keyboard and mouse
- Wi-Fi with internet connectivity

You will also need a Mycroft developer account: https://home.mycroft.ai

Hardware setup
---
- Make sure the DragonBoard is powered off
- Connect I/O devices (Monitor, Keyboard, etc...)
- Connect AiVA-96 boards on top of DragonBoard
- Connect AiVA-96 MEMS mic board and speakers
- Power on your DragonBoard 410c with 96Boards compliant power supply
- To make sure the microphone and speakers are connected successfully, go to Application Menu -> Sound & Video -> PulseAudio Volume Control and check the input and output device, set as "WizeIoT AiVA-96 DevKit (UAC1.0) Analog Stereo". 

    ![AiVA-96 and DB410c](https://github.com/wizeiot/aiva-96-alexa-avs-sample/wiki/assets/aiva_db410c.jpg)

Debian installation and Dragon Board 410c audio setup
---
Full instructions to install the AVS SDK on to a Dragon Board 410c and configure the audio to use the AiVA-96 are detailed in the Getting Started Guide available from: https://www.wizeiot.com/aiva-96/ home page.

Brief instructions and additional notes are below:

1. Install Debian (Stretch) on the DragonBoard 410c
   + You shoud use [Debian 17.09](http://releases.linaro.org/96boards/dragonboard410c/linaro/debian/17.09/dragonboard410c_sdcard_install_debian-283.zip),  [Debian 18.01](http://releases.linaro.org/96boards/dragonboard410c/linaro/debian/18.01/dragonboard-410c-sdcard-installer-buster-359.zip) or higher. Note: '*apt-get upgrade*' from 18.01 possibly bring boot crash. You may hold kernel upgrade with below command line, before package upgrade.
    ```
    sudo apt-mark hold linux-image-4.14.0-qcomlt-arm64
    ```   

   + Write downloaded image file to your MicroSD card with [Etcher](https://etcher.io/) or other image writer software.
   + Turn on DragonBoard 410c's 'SD BOOT' dip switch and power on to install Debian.

2. Audio testing: This helps us do a simple speaker and microphone test, just to make sure that the hardware is functional.
    ```
    $ speaker-test -t wav
    $ arecord --format=S16_LE --duration=5 --rate=16000 --file-type=raw out.raw
    $ aplay --format=S16_LE --rate=16000 --file-type=raw out.raw
    ```

3. Open a terminal on the Dragon Board 410c and clone this repository
    ```
    cd ~; git clone https://github.com/wizeiot/aiva-96-mycroft.git
    ```   

4. Run the installation script
    ```
    cd aiva-96-mycroft/
    bash automated_install.sh
    ```
    IMPORTANT: This script sets up dependencies and a [virtualenv][about-virtualenv].  If running in an environment besides Ubuntu/Debian, Arch or Fedora you may need to manually install packages as instructed by dev_setup.sh.

    [about-virtualenv]:https://virtualenv.pypa.io/en/stable/

    NOTE: The default branch for 'mycroft-core' is 'dev', which should be considered a work-in-progress. If you want to clone a more stable version, switch over to the 'master' branch.

5. Alternative way to setup SDK:
    If you wish recompile software, you can directly run script as below.
    ```
    cd ~/aiva-96-mycroft/mycroft-core
    bash dev_setup.sh
    ```

# Running Mycroft

Mycroft provides `start-mycroft.sh` to perform common tasks. This script uses a virtualenv created by `dev_setup.sh`.  Assuming you installed mycroft-core in your home directory run:
- `cd ~/aiva-96-mycroft/mycroft-core`
- `./start-mycroft.sh debug`

The "debug" command will start the background services (microphone listener, skill, messagebus, and audio subsystems) as well as bringing up a text-based Command Line Interface (CLI) you can use to interact with Mycroft and see the contents of the various logs. Alternatively you can run `./start-mycroft.sh all` to begin the services without the command line interface.  Later you can bring up the CLI using `./start-mycroft.sh cli`.

The background services can be stopped as a group with:
- `./stop-mycroft.sh`

# Using Mycroft

## *Home* Device and Account Manager
Mycroft AI, Inc. maintains a device and account management system known as Mycroft Home. Developers may sign up at: https://home.mycroft.ai

By default, mycroft-core  is configured to use Home. By saying "Hey Mycroft, pair my device" (or any other request verbal request) you will be informed that your device needs to be paired. Mycroft will speak a 6-digit code which you can entered into the pairing page within the [Mycroft Home site](https://home.mycroft.ai).

Once paired, your unit will use Mycroft API keys for services such as Speech-to-Text (STT), weather and various other skills.

## Skills

Mycroft is nothing without skills.  There are a handful of default skills that are downloaded automatically to your `/opt/mycroft/skills` directory, but most need to be installed explicitly.  See the [Skill Repo](https://github.com/MycroftAI/mycroft-skills#welcome) to discover skills made by others.  And please share your own interesting work!

# Behind the scenes

## Pairing Information
Pairing information generated by registering with Home is stored in:
`~/.mycroft/identity/identity2.json` <b><-- DO NOT SHARE THIS WITH OTHERS!</b>

## Configuration
Mycroft configuration consists of 4 possible locations:
- `aiva-96-mycrofot/mycroft-core/mycroft/configuration/mycroft.conf`(Defaults)
- [Mycroft Home](https://home.mycroft.ai) (Remote)
- `/etc/mycroft/mycroft.conf`(Machine)
- `$HOME/.mycroft/mycroft.conf`(User)

When the configuration loader starts, it looks in these locations in this order, and loads ALL configurations. Keys that exist in multiple configuration files will be overridden by the last file to contain the value. This process results in a minimal amount being written for a specific device and user, without modifying default distribution files.

## Using Mycroft Without Home

If you do not wish to use the Mycroft Home service, you may insert your own API keys into the configuration files listed below in <b>configuration</b>.

The place to insert the API key looks like the following:

`[WeatherSkill]`
`api_key = ""`

Put a relevant key inside the quotes and mycroft-core should begin to use the key immediately.

## API Key Services

These are the keys currently used in Mycroft Core:

- [STT API, Google STT, Google Cloud Speech](http://www.chromium.org/developers/how-tos/api-keys)
- [Weather Skill API, OpenWeatherMap](http://openweathermap.org/api)
- [Wolfram-Alpha Skill](http://products.wolframalpha.com/api/)

## Using Mycroft behind a proxy

Many schools, universities and workplaces run a `proxy` on their network. If you need to type in a username and password to access the external internet, then you are likely behind a `proxy`.

If you plan to use Mycroft behind a proxy, then you will need to do an additional configuration step.

_NOTE: In order to complete this step, you will need to know the `hostname` and `port` for the proxy server. Your network administrator will be able to provide these details. Your network administrator may want information on what type of traffic Mycroft will be using. We use `https` traffic on port `443`, primarily for accessing ReST-based APIs._

### Using Mycroft behind a proxy without authentication

If you are using Mycroft behind a proxy without authentication, add the following environment variables, changing the `proxy_hostname.com` and `proxy_port` for the values for your network. These commands are executed from the Linux command line interface (CLI).

```bash
$ export http_proxy=http://proxy_hostname.com:proxy_port
$ export https_port=http://proxy_hostname.com:proxy_port
$ export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,0.0.0.0,::1"
```

### Using Mycroft behind an authenticated proxy

If  you are behind a proxy which requires authentication, add the following environment variables, changing the `proxy_hostname.com` and `proxy_port` for the values for your network. These commands are executed from the Linux command line interface (CLI).

```bash
$ export http_proxy=http://user:password@proxy_hostname.com:proxy_port
$ export https_port=http://user:password@proxy_hostname.com:proxy_port
$ export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,0.0.0.0,::1"
```

Enjoy your Mycroft-core and don't forget to visit https://www.iotoi.io community for find out more projects.

# Links
* [Creating a Skill](https://docs.mycroft.ai/skill.creation)
* [Documentation](https://docs.mycroft.ai)
* [Release Notes](https://github.com/MycroftAI/mycroft-core/releases)
* [Mycroft Chat](https://chat.mycroft.ai)
* [Mycroft Forum](https://community.mycroft.ai)
* [Mycroft Blog](https://mycroft.ai/blog)