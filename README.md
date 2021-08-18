# barcode-scanner-rpi-4
 MQTT data transmission for barcode scanner using paho MQTT
 # Use Raspberry Terminal

 ## 0 - Enable SPI and Serial Port by using the following command
```
sudo raspi-config
```

 ## 1 - Execute Main script
```
git clone https://github.com/hanifr/barcode-scanner-rpi-4.git
cd barcode-scanner-rpi-4
./init.sh
```

## 2 - Optional: Run Barcode Scanner service on boot
```
./startup.sh
```
