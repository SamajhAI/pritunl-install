sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt focal main
EOF

sudo apt --assume-yes install gnupg
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
sudo apt update
sudo apt install pritunl-client
pritunl-client add pritunl://pritunl.samajh.ai/ku/dKrerva4

PROFILE_NAME=$(pritunl-client list | grep -oP '^\d+\. \K.*')
# Output the profile name
echo "Profile Name: $PROFILE_NAME"

# Start the VPN connection using the extracted profile name
pritunl-client start "$PROFILE_NAME"

# Verify the connection status
pritunl-client status "$PROFILE_NAME"
