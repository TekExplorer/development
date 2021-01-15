#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Add Docker's GPG key and configure the repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Add support for easily fetching the latest version of Go
add-apt-repository ppa:longsleep/golang-backports

# Perform the installation of the required software.
apt -y update
apt -y --no-install-recommends install tar zip unzip make gcc g++ python docker-ce docker-ce-cli containerd.io golang-go

# Configure the vagrant user to have permission to use Docker.
usermod -aG docker vagrant

# Ensure docker is started and will continue to start up.
systemctl enable docker --now

# Install ctop for easy container metrics visualization.
curl -fsSL https://github.com/bcicen/ctop/releases/download/v0.7.1/ctop-0.7.1-linux-amd64 -o /usr/local/bin/ctop
chmod +x /usr/local/bin/ctop

# Move certificates to sensible default locations
cp /etc/ssl/pterodactyl/rootCA.pem /etc/ssl/certs/mkcert.pem
mkdir -p /etc/letsencrypt/live/wings.pterodactyl.test/
cp /etc/ssl/pterodactyl/pterodactyl.test.pem /etc/letsencrypt/live/wings.pterodactyl.test/fullchain.pem
cp /etc/ssl/pterodactyl/pterodactyl.test-key.pem /etc/letsencrypt/live/wings.pterodactyl.test/privkey.pem

# create config directory
mkdir /etc/pterodactyl /var/log/pterodactyl

# ensure permissions are set correctly
chown -R vagrant:vagrant /home/vagrant /etc/pterodactyl /var/log/pterodactyl

# map pterodactyl.test to the host system
echo "$(ip route | grep default | cut -d' ' -f3,3) pterodactyl.test" >> /etc/hosts

echo "done."