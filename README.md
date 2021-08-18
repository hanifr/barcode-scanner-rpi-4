# barcode-scanner-rpi-4
 MQTT data transmission for barcode scanner using paho MQTT
 # Use Raspberry Terminal

 ## 0 - Enable SPI and Serial Port by using the following command
```
sudo raspi-config
```

 ## 1 - Execute Main script
```
git clone https://github.com/hanifr/dragino-GPS-RPi-shield.git
cd dragino-GPS-RPi-shield
./init.sh
```
## 2 - Disable HCIUART
```
./hciuartdisable.sh
```

## 4 - Optional: Run GPS and LoRa services on boot
```
./startup.sh
```

## 5 - Optional: Run Node-red on boot
```
./initnodered.sh
```
