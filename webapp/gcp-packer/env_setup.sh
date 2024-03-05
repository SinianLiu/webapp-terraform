#!/bin/bash

set -e

sudo dnf install unzip -y
sudo dnf module enable nodejs:20 -y
sudo dnf install nodejs -y

echo "node environment has been set up successfully!"
