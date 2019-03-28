[![Documentation Status](https://readthedocs.org/projects/ztpmanager/badge/?version=latest)](https://docs.networkbootstrap.com/en/latest/?badge=latest)
[![Go Report Card](https://goreportcard.com/badge/github.com/networkbootstrap/ztpmanagercode)](https://goreportcard.com/report/github.com/networkbootstrap/ztpmanagercode)
[![Build Status](https://travis-ci.org/networkbootstrap/ztpmanagercode.svg?branch=master)](https://travis-ci.org/networkbootstrap/ztpmanagercode)
## ZTP Manager

ZTP Manager is a wrapper for the [ISC DHCP Server](https://www.isc.org/downloads/dhcp/) which enables you to do zero-touch provisioning for network devices. The wrapper has a HTTP JSON API for ease of configuration.

This wrapper not only provides automatic configuration generation for the `/etc/dhcp/dhcpd.conf` file, but also the `/etc/default/isc-dhcp-server` file and initial golden configurations for the devices. 

Take a fresh installation of Ubuntu LTS (16.04 / 18.04) and make sure everything is updated.

For docs, take a look [here](https://docs.networkbootstrap.com).
Here is a YouTube video for the initial release! [https://www.youtube.com/watch?v=3Wz4COk-ae4](https://www.youtube.com/watch?v=3Wz4COk-ae4)

## Installation

Installation is super simple. You are required to know the physical interface you wish to servce DHCP on and the server URL for the API. Be sure to change the below line to reflect this. Both configuration items can be found at the end of the line.

`curl -sSL https://raw.githubusercontent.com/networkbootstrap/ztpmanager/master/install.sh | bash -s -- --url=ztp.simpledemo.net --iface=ens34`

## Usage

If you take a look at the `config.toml` file and you'll see one host already configured. It's possible to initially create hosts here as well as through the JSON API.

__NOTE__ that when creating or deleting resources through the JSON API, you must __save__ afterwards for the configuration change to impact the `dhcpd.conf` file!!! This is important!!!

__Create Hosts__

```bash
curl -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Basic YWRtaW46UGFzc3cwcmQ=" \
  -d '{
    "ethernetaddress": "00:0c:29:4d:3d:cd",
    "fixedipaddress": "192.168.50.101",
    "hostname": "demo02",
    "vendor": "junos"
    }' \
   REPLACE_WITH_SERVER_IP:1323/hosts
```
__Delete Hosts__

```bash
curl -X DELETE -H 'Content-Type: application/json' \ 
    -H "Authorization: Basic YWRtaW46UGFzc3cwcmQ=" \
    REPLACE_WITH_SERVER_IP:1323/hosts/REPLACE_WITH_HOST_IP
```
__Get Hosts__

```bash
curl -X GET -H "Authorization: Basic YWRtaW46UGFzc3cwcmQ=" \
    http://REPLACE_WITH_SERVER_IP:1323/hosts
```

__Get Individual Hosts__

```bash
curl -X GET -H "Authorization: Basic YWRtaW46UGFzc3cwcmQ=" \
    http://REPLACE_WITH_SERVER_IP:1323/hosts/REPLACE_WITH_HOST_IP
```

__Save__

```bash
curl -X POST -H 'Content-Type: application/json' \
    -H "Authorization: Basic YWRtaW46UGFzc3cwcmQ=" \
    REPLACE_WITH_SERVER_IP:1323/save
```
