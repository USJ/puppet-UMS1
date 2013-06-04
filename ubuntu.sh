#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 12.04 LTS.
#
set -e

# Load up the release information
. /etc/lsb-release

REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Do the initial apt-get update
echo "Initial apt-get update..."
apt-get -y update >/dev/null
# apt-get -f install

# Install wget if we have to (some older Ubuntu versions)
echo "Installing wget..."
apt-get install -y wget >/dev/nullch

# Upgrade ubuntu
echo "Upgrade ubuntu to latest minor version"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade >/dev/null

# Install the PuppetLabs repo
# echo "Configuring PuppetLabs repo..."
# repo_deb_path=$(mktemp)
# wget --output-document=${repo_deb_path} ${REPO_DEB_URL} 2>/dev/null
# dpkg -i ${repo_deb_path} >/dev/null
# apt-get update >/dev/null

# # Install Puppet
# echo "Installing Puppet..."
# apt-get install -y puppet >/dev/null

# echo "Puppet installed!"