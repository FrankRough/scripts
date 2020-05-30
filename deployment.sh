#!/usr/bin/env bash
# Script by Daniel Cardenas to automate few deployment steps

echo "Hello, $(whoami)!"
echo "Lets install Python3, NGINX, Postgres"

sudo apt-get update
sudo apt install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx curl
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv

echo "Lets configure firewall for Nginx"

sudo ufw app list
sudo ufw allow "Nginx HTTP"

echo "Lets clone your project now! Enter your project name"
echo "Enter your github username"
read github_username
echo "Enter your github project name"
read github_projectname
git clone https://github.com/$github_username/$github_projectname.git /home/deploy/$github_projectname
echo "Creating virtualenv"
virtualenv /home/deploy/$github_projectname/venv

echo "Activating and installing pip requirements"
source /home/deploy/$github_projectname/venv/bin/activate

pip install -r /home/deploy/$github_projectname/requirements.txt

echo "Open port 8000"
sudo ufw allow 8000

echo "Gunicorn configuration"
 sudo -- bash -c 'echo "

 [Unit]
 Description=gunicorn socket

 [Socket]
 ListenStream=/run/gunicorn.sock

 [Install]
 WantedBy=sockets.target" >> /etc/systemd/system/gunicorn.socket'

