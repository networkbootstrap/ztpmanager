## ZTP Manager

ZTP Manager is a wrapper for the [ISC DHCP Server](https://www.isc.org/downloads/dhcp/) which enables you to do zero-touch provisioning for network devices. The wrapper has a HTTP JSON API for ease of configuration.

This wrapper not only provides automatic configuration generation for the `/etc/dhcp/dhcpd.conf` file, but also the `/etc/default/isc-dhcp-server` file and initial golden configurations for the devices. 

Take a fresh installation of Ubuntu LTS (16.04 / 18.04) and make sure everything is updated.

## Installation

Installation is super simple. You are required to know the physical interface you wish to servce DHCP on and the server URL for the API. Be sure to change the below line to reflect this. Both configuration items can be found at the end of the line.

`curl -sSL https://raw.githubusercontent.com/networkbootstrap/ztpmanager/master/install.sh | bash -s -- --url=ztp.simpledemo.net --iface=ens34`

## Usage

If you take a look at the `config.toml` file and you'll see one host already configured. It's possible to initially create hosts here as well as through the JSON API.

__Create Hosts__

curl -X POST \
  -H 'Content-Type: application/json' \
  -d '{
    "ethernetaddress": "00:0c:29:4d:3d:cd",
    "fixedipaddress": "192.168.50.101",
    "hostname": "demo02",
    "vendor": "junos"
    }' \
   REPLACE_WITH_SERVER_IP:1323/hosts

__Delete Hosts__

curl -X DELETE -H 'Content-Type: application/json' REPLACE_WITH_SERVER_IP:1323/hosts/REPLACE_WITH_HOST_IP

__Get Hosts__

curl -X GET http://REPLACE_WITH_SERVER_IP:1323/hosts

__Get Individual Hosts__

curl -X GET http://REPLACE_WITH_SERVER_IP:1323/hosts/<HOST_IP>

__Save__

curl -X POST -H 'Content-Type: application/json' REAPLCE_WITH_SERVER_IP:1323/save



 
