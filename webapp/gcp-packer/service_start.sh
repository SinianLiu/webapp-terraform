#!/bin/bash

sudo mv /tmp/webapp.service /etc/systemd/system/webapp.service

# webapp is the name of the service
sudo systemctl daemon-reload
sudo systemctl enable webapp

echo "Service start successfully!"
