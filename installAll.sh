#!/bin/bash

# Get the Ubuntu version
UBUNTU_VERSION=$(lsb_release -r | awk '{print $2}')

# Function to install Pritunl client for Ubuntu 20.04
install_pritunl_2004() {
  sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt focal main
EOF

  sudo apt --assume-yes install gnupg
  gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
  gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
  sudo apt update
  sudo apt install pritunl-client
}

# Function to install Pritunl client for Ubuntu 23.10
install_pritunl_2310() {
  sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt mantic main
EOF

  sudo apt --assume-yes install gnupg
  gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
  gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
  sudo apt update
  sudo apt install pritunl-client-electron
}

# Function to install Pritunl client for Ubuntu 24.04
install_pritunl_2404() {
  sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt noble main
EOF

  sudo apt --assume-yes install gnupg
  gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
  gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
  sudo apt update
  sudo apt install pritunl-client-electron
}

# Function to configure and start Pritunl client
configure_pritunl() {
  PRITUNL_PROFILE_URL="ADD_URL_HERE"
  pritunl-client add "$PRITUNL_PROFILE_URL"

  PROFILE_NAME=$(pritunl-client list | grep -oP '^\d+\. \K.*')
  echo "Profile Name: $PROFILE_NAME"
  pritunl-client start "$PROFILE_NAME"
  pritunl-client status "$PROFILE_NAME"
}

# Check the Ubuntu version and execute the corresponding function
case $UBUNTU_VERSION in
  "20.04")
    install_pritunl_2004
    ;;
  "23.10")
    install_pritunl_2310
    ;;
  "24.04")
    install_pritunl_2404
    ;;
  *)
    echo "Unsupported Ubuntu version: $UBUNTU_VERSION"
    exit 1
    ;;
esac

# Run the common configuration steps
configure_pritunl
