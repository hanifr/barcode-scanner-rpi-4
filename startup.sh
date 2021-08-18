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

# cd /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/
sudo python3 /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/gps_simple.py

EOL
sudo mv /tmp/startbarscan.sh /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startbarscan.sh
sudo chmod 744 /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startbarscan.sh


sudo cat >/tmp/gpsdragino.service <<EOL
[Unit]
Description=GPS module service
Wants=network.target
After=loradragino.service
StartLimitInterval=400
StartLimitBurst=3
[Service]
Type=simple
ExecStart=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startbarscan.sh
Restart=on-failure
RestartSec=90
User=pi
[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/gpsdragino.service /etc/systemd/system/gpsdragino.service
echo "${_YELLOW}[*] Starting gpsdragino systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/gpsdragino.service
sudo systemctl daemon-reload
sudo systemctl enable gpsdragino.service
sudo systemctl start gpsdragino.service

echo "${_YELLOW}To see GPS startup service logs run \"sudo journalctl -u loradragino -f\" command${_RESET}"
echo
echo "${_MAGENTA}Setup Progress....Creating Barcode Scanner startup service:: finished${_RESET}"
echo
 