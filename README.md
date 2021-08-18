# barcode-scanner-rpi-4
 MQTT data transmission for wireless barcode scanner using paho MQTT. This script is tested on Netum Wireless Barcode Scanner (https://shopee.com.my/2-4G-Netum-Wireless-Laser-Barcode-Scanner-Cordless-Long-Range-Reader-Inventory-POS--i.65606388.5441012553?gclid=CjwKCAjw3_KIBhA2EiwAaAAlilljxIjqH3A9Qb19sykjPkEltcH9ThaKyAy5m32Y4roTSFHe8H-U-BoCUsQQAvD_BwE)
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
