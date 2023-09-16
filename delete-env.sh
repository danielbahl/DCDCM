#!/bin/bash

# Define initial variables 📚
domain=$1
sitesEnabled='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
userDir='/var/www/'

# Check if the script is run as root 🤔
if [ "$(whoami)" != 'root' ]; then
  echo -e "\033[0;91m 😱 Sorry mate, you need superpowers to run this. Use sudo or become root. 😱\033[0m"
  exit 1;
fi

# Clear screen for a fresh start 🌈
clear

# Some colorful welcoming vibes to the small delete script 🎉
echo -e "\033[0;92m ✨ Welcome to the Dev Environment DELETER v1.1.7 ✨\033[0m"
echo -e "          \033[1;33mCaution! Dragons ahead! 🐉\033[0m"
echo ""

# Display Apache2 sites in a tech-genius manner 😎
echo -e "\033[0;96m 🤓 Your current Apache2 Sites 🚀 \033[0m"
ls /etc/apache2/sites-available/ | grep -vE '(000-default|-le-ssl)' | sed 's/\.conf//g'
echo ""

# Loop until a domain name is provided by the user ⏳
while [ -z "$domain" ]; do
  echo -e "🎤 Enter the username you wish to delete from the list above:"
  read -p "🚀 Your input: " domain
done

# Check if the domain's Apache2 config files exist 📋
if [ ! -f "$sitesAvailable$domain.conf" ]; then
  echo -e "\033[0;91m 😱 The domain's Apache2 config files don't exist. Aborting! 😱 \033[0m"
  exit 1;
fi

# Final confirmation before the great purge 💥
# Final confirmation before the great purge 💥
echo -e "\033[0;93m 🤔 Are you sure you want to delete $domain? This action cannot be undone. (Y/n) 🤔 \033[0m"
echo -e "\033[0;93m 📂 The following will be deleted if you proceed: 📂 \033[0m"
echo -e "\033[0;91m 1. Apache2 Site Configuration: $sitesAvailable$domain.conf 📜\033[0m"
echo -e "\033[0;91m 2. Apache2 SSL Configuration: $sitesAvailable$domain-le-ssl.conf 📜\033[0m"
echo -e "\033[0;91m 3. Website Directory: $userDir$domain 🗂️\033[0m"
echo ""
echo -e "\033[0;91m !! This script will _NOT!_ touch your Github repo. !!\033[0m"
echo ""

read -p "🎤 Your input: " confirmation
if [ "$confirmation" != "Y" ]; then
  echo -e "\033[0;91m 😅 Phew! That was close. Aborting! 😅 \033[0m"
  exit 1;
fi

# Disable the Apache2 sites and remove their config files 🔥
a2dissite $domain
a2dissite $domain-le-ssl
systemctl reload apache2

# Deleting Apache2 config files 🗑️
rm "$sitesAvailable$domain.conf"
rm "$sitesAvailable$domain-le-ssl.conf"

# Deleting the user directory 🗑️
if [ -d "$userDir$domain" ]; then
  rm -rf "$userDir$domain"
fi

echo -e "\033[0;92m 🎉 Yay, $domain has been successfully deleted! 🎉 \033[0m"
