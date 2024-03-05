#!/bin/bash

set -e

sudo dnf install postgresql-server postgresql-contrib -y
sudo postgresql-setup --initdb
sudo chmod 755 /home/packer

sudo sed -i 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf

sudo systemctl start postgresql
sudo systemctl enable postgresql

sudo systemctl status postgresql
echo "Should be active and running"


sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '123456';"
PGPASSWORD=123456 psql -h localhost -U postgres -c "CREATE DATABASE webapp;"

echo "Postgres DB has been set up successfully!"




# sudo dnf module enable postgresql:12
# sudo dnf install postgresql-server
# sudo postgresql-setup --initdb
# sudo systemctl start postgresql
# sudo systemctl enable postgresql


# sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '123456';"
# sudo -u postgres psql -c "CREATE DATABASE assignment3 OWNER postgres;"
