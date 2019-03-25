#!/bin/bash

echo 'Installing ZTP server manager framework and ISC-DHCP-SERVER'

ARCH=$(arch)
DEBTEST=`lsb_release -a 2> /dev/null | grep Distributor | awk '{print $3}'`

sudo apt-get install -y isc-dhcp-server=4.3.5-3ubuntu7
sudo apt-get install -y git

URL="ztp.localhost"

setup_args() {
  for i in "$@"
    do
      case $i in
 	  # Server URL location.
          --url=*)
          URL="${i#*=}"
          shift
          ;;
	  --iface=*)
          IFACE="${i#*=}"
	  shift
	  ;;
          *)
          # unknown option
          ;;
      esac
    done
}

setup_args $@

if [ "$ARCH" != "x86_64" ]; then
  echo "Unsupported architecture. Please use a 64-bit OS! Aborting!"
  exit 2
fi

echo "Architecture is x86_64. Good!"

if [ -n "$DEBTEST" ]; then
  TYPE="debs"
  echo "*** Detected Distro is ${DEBTEST} ***"
  SUBTYPE=`lsb_release -a 2>&1 | grep Codename | grep -v "LSB" | awk '{print $2}'`
  echo "*** Detected flavor ${SUBTYPE} ***"

  if [ "$SUBTYPE" != 'trusty' && "$SUBTYPE" != 'xenial' && "$SUBTYPE" != 'bionic' ]; then
    echo "Unsupported ubuntu flavor ${SUBTYPE}. Please use 16.04 (xenial) or 18.04 (bionic) as base system!"
    exit 2
  fi

fi


# Now we download the binary using CURL and do an MD5 on it to ensure it's the same. Users can of course build from source if they require and validate the MD5.

git clone https://github.com/networkbootstrap/ztpmanagerassets.git
cd ztpmanagerassets
# curl -sS -k -o ztpmanager https://raw.githubusercontent.com/networkbootstrap/ztpmanager/master/ztpmanager
# curl -sS -k -o ztpmanager.md5 https://raw.githubusercontent.com/networkbootstrap/ztpmanager/master/ztpmanager.md5
# curl -sS -k -o config.toml https://raw.githubusercontent.com/networkbootstrap/ztpmanager/master/config.toml
# wget -r https://raw.githubusercontent.com/networkbootstrap/ztpmanager/master/templates

md5sum ztpmanager | awk '{print $1}' > calculated.md5
file1="calculated.md5"
file2="ztpmanager.md5"

if ! cmp "$file1" "$file2"; then
echo "MD5 comparison failed, exiting..."
exit 1
fi

echo "MD5 file comparison passed..."

sed -i "s/  ServerURL = \"localhost\"/  ServerURL = \"$URL\"/g" config.toml
sed -i "s/  DHCPIface = \"ens34\"/  DHCPIface = \"$IFACE\"/g" config.toml

echo "Restarting ISC server..."
sudo service isc-dhcp-server restart
echo "Restarted ISC server..."

chmod a+x ztpmanager

echo "Creating default config and image directories..."
mkdir configs
mkdir images
echo "Created default config and image directories..."

echo "Starting service"
sudo ./ztpmanager -config config.toml &
