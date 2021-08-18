#!/bin/bash
# Colors
_RED=`tput setaf 1`
_GREEN=`tput setaf 2`
_YELLOW=`tput setaf 3`
_BLUE=`tput setaf 4`
_MAGENTA=`tput setaf 5`
_CYAN=`tput setaf 6`
_RESET=`tput sgr0`
# printing greetings

echo "${_MAGENTA}Setup Progress....Creating Barcode Scanner startup service:: started${_RESET}"
echo


sudo cat >/tmp/startbarscan.sh <<EOL
#!/bin/bash

# cd /home/pi/barcode-scanner-rpi-4/paho.mqtt.python/examples/
sudo python3 /home/pi/barcode-scanner-rpi-4/paho.mqtt.python/examples/barcodescanner.py

EOL
sudo mv /tmp/startbarscan.sh /home/pi/barcode-scanner-rpi-4/paho.mqtt.python/examples/startbarscan.sh
sudo chmod 744 /home/pi/barcode-scanner-rpi-4/paho.mqtt.python/examples/startbarscan.sh


sudo cat >/tmp/netumscan.service <<EOL
[Unit]
Description=Barcode Scanner module service
After=network.target
StartLimitInterval=400
StartLimitBurst=3
[Service]
Type=simple
ExecStart=/home/pi/barcode-scanner-rpi-4/paho.mqtt.python/examples/startbarscan.sh
Restart=on-failure
RestartSec=90
User=pi
[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/netumscan.service /etc/systemd/system/netumscan.service
echo "${_YELLOW}[*] Starting netumscan systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/netumscan.service
sudo systemctl daemon-reload
sudo systemctl enable netumscan.service
sudo systemctl start netumscan.service

echo "${_YELLOW}To see GPS startup service logs run \"sudo journalctl -u netumscan -f\" command${_RESET}"
echo
echo "${_MAGENTA}Setup Progress....Creating Barcode Scanner startup service:: finished${_RESET}"
echo
 