#!/bin/bash
sudo cp ./bootsplash.armbian /usr/lib/firmware/bootsplash.armbian
sudo update-initramfs -v -u
