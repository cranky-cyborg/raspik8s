/bin/bash

echo "Running Raspberry Pi Confuguration"

echo "But first, Lets capture a few key information:"

read -p "Host name: " hostname

# Via https://gist.github.com/damoclark/ab3d700aafa140efb97e510650d9b1be
# Execute the config options starting with 'do_' below
grep -E -v -e '^\s*#' -e '^\s*$' <<END | \
sed -e 's/$//' -e 's/^\s*/\/usr\/bin\/raspi-config nonint /' | bash -x -
#
# Drop this file in SD card root. After booting run: sudo /boot/setup.sh
# --- Begin raspi-config non-interactive config option specification ---

# Hardware Configuration
do_boot_wait 0            # Turn off waiting for network before booting
do_boot_splash 1          # Disable the splash screen
do_overscan 1             # Disable overscan
do_ssh 0                  # Enable remote ssh login

# System Configuration
do_configure_keyboard us                     # Specify US Keyboard
do_hostname ${hostname}                      # Set hostname from Parameter
do_wifi_country NZ                           # Set wifi country as New Zealand
#do_wifi_ssid_passphrase ${wifissid} ${wifipasswd}   # Set wlan0 network to join wifi
do_change_timezone Pacific/Auckland          # Change timezone to Auckland
do_change_locale en_NZ.UTF-8                 # Set language to New Zealand English

# Don't add any raspi-config configuration options after 'END' line below & don't remove 'END' line
END

#Turn off Swapfiles

echo "Turning off SWAP"
dphys-swapfile swapoff
dphys-swapfile uninstall
update-rc.d dphys-swapfile remove
systemctl disable dphys-swapfile.service
apt-get remove dphys-swapfile dc

/usr/bin/raspi-config do_change_pass          # Interactively set password for your login
#/usr/bin/raspi-config do_wifi_ssid_passphrase # Interactively configure the wifi network
