#!/bin/bash

set -e

sudo mkdir -p /opt/myapp

sudo unzip /tmp/webapp.zip -d /opt/myapp
sudo mv /tmp/.env /opt/myapp/.env


# shellcheck disable=SC2164
cd /opt/myapp
sudo npm install

# permisson setup to the folder should be put at the end
sudo chown -R csye6225:csye6225 /opt/myapp
sudo chmod -R 755 /opt/myapp

echo "webapp has been unzipped successfully!"

# sudo mv /tmp/* /opt/myapp
# 在 unzip 命令中，-o 选项用于覆盖已存在的文件，而不是询问用户是否覆盖。
# set -e 当任何语句的执行结果不是true，立即退出脚本。
# -p 选项会创建所有必要的父目录，并且如果目录已经存在则不会报错。
# -R 选项会递归地更改指定目录及其所有子目录和文件的所有者。
