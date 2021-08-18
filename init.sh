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

echo "${_MAGENTA}Installation Progress....setup for for Wireless Netum Barcode Scanner data acquisition protocol :: started${_RESET}"
echo
sleep 5
chmod +x startup.sh
echo "${_MAGENTA}Installation Progress....set local time to Kuala Lumpur${_RESET}"
echo
sudo timedatectl set-timezone Asia/Kuala_Lumpur

# Installation of Python Dependencies and GPS Libaries
echo "${_MAGENTA}Installation Progress...installation of GPS Python Library${_RESET}"
echo
sudo pip3 install evdev==1.2.0

echo "${_MAGENTA}Installation Progress....installation of MQTT PAHO${_RESET}"
echo
git clone https://github.com/eclipse/paho.mqtt.python.git
cd ./paho.mqtt.python
sudo python setup.py install

sleep 5
echo "${_CYAN}Please Enter the MQTT domain_name${_RESET} $_domain"
                read -p "Entered the MQTT domain_name: " _domain
echo
echo "${_CYAN}Please Enter the MQTT topic to publish data${_RESET} $_topic"
                read -p "Entered the MQTT topic_name: " _topic
echo
echo "${_CYAN}You have entered $_domain for MQTT server and $_topic for the topic${_RESET}"

# start doing stuff: preparing script for GPS data acquisition
# preparing script background work and work under reboot
echo "[*] Creating Barcode Scanner data acquisition script"

cat >/tmp/barcodescanner.py <<EOL
#!/usr/bin/env python3
import paho.mqtt.publish as publish
from evdev import InputDevice, ecodes, list_devices, categorize
import signal, sys
barCodeDeviceString = "HID 1a86:5455 Keyboard" # barcode device name
scancodes = {
    # Scancode: ASCIICode
    0: None, 1: u'ESC', 2: u'1', 3: u'2', 4: u'3', 5: u'4', 6: u'5', 7: u'6', 8: u'7', 9: u'8',
    10: u'9', 11: u'0', 12: u'-', 13: u'=', 14: u'BKSP', 15: u'TAB', 16: u'Q', 17: u'W', 18: u'E', 19: u'R',
    20: u'T', 21: u'Y', 22: u'U', 23: u'I', 24: u'O', 25: u'P', 26: u'[', 27: u']', 28: u'CRLF', 29: u'LCTRL',
    30: u'A', 31: u'S', 32: u'D', 33: u'F', 34: u'G', 35: u'H', 36: u'J', 37: u'K', 38: u'L', 39: u';',
    40: u'"', 41: u'`', 42: u'LSHFT', 43: u'\\', 44: u'Z', 45: u'X', 46: u'C', 47: u'V', 48: u'B', 49: u'N',
    50: u'M', 51: u',', 52: u'.', 53: u'/', 54: u'RSHFT', 56: u'LALT', 100: u'RALT'
}
def signal_handler(signal, frame):
    print('Stopping')
    dev.ungrab()
    sys.exit(0)
if __name__ == '__main__':
    # find usb hid device
    dev = InputDevice("/dev/input/event0")
    signal.signal(signal.SIGINT, signal_handler)
    dev.grab()
    # process usb hid events and format barcode data
    barcode = ""
    try:
        for event in dev.read_loop():
            if event.type == ecodes.EV_KEY:
                data = categorize(event)
                if data.keystate == 1 and data.scancode != 42: # Catch only keydown, and not Enter
                    key_lookup = scancodes.get(data.scancode) or u'UNKNOWN:{}'.format(data.scancode) # lookup corresponding ascii value
                    if data.scancode == 28: # if enter detected print barcode value and then clear it
                        print(barcode)
                        publish.single("$_topic", barcode, hostname="$_domain")
                        barcode = ""
                    else:
                        barcode += key_lookup # append character to barcode string
    except KeyboardInterrupt:
        dev.close()
EOL
sudo mv /tmp/barcodescanner.py /home/pi/barcode-scanner-rpi-4/paho.mqtt.python/examples/barcodescanner.py

sleep 5
echo
echo "${_YELLOW} The Barcode scanner is ready for use.${_RESET}"
echo "${_YELLOW} use Node-Red to invoke the Barcode scanner data.${_RESET}"
echo "${_YELLOW} Please import barcode.json into Node-Red.${_RESET}"
echo
echo "${_MAGENTA}Please do the following${_RESET}"
echo "${_CYAN}Go to configuration section by${_RESET}"
echo "${_CYAN}\"sudo raspi-config\"${_RESET}"
echo
echo "${_CYAN}Then enter activate SPI and Serial Port${_RESET}"
echo
sleep 5
echo "${_CYAN}Now execute the following command${_RESET}"
echo "${_CYAN}\"sudo python3 /usr/local/lib/python3.7/dist-packages/evdev/evtest.py\"${_RESET}"
sleep 5