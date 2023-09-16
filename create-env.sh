#!/bin/bash

#----------------------------------------------
# Virtual Host Creation Script for my VS Code Setup
# Author: Daniel Bahl
# Date: 2023-09-01
# Description: This script sets up an Apache Virtual Host, 
# configures SSL using Certbot, and sets up a new
# or existing Github repo.
# This is used for my personal VS Code Dev Setup!
#----------------------------------------------

# Git-related variables
### Git Vars
gitName='Daniel Bahl'  # Your Git username
gitMail='me@yourdomain.dev'  # Your Git email
gitUsername='danielbahl'  # Your GitHub or other Git platform username

# Software Licenses
## Intelephense
### I use the commercial VS Code Plugin intelephense
### It's pretty awesome if you write php code 🐘
### If you have a license, then define this variable
### otherwise leave it empty:
intelephenseLicense='' # License Key 

# UserName
### The Username that owns the code, could be 'yourname' or 'myname' 😜
ownerUsername='piraffe'
ownerGroup='webmasters'

# Cloudflare-related variables for DNS setup
## Cloudflare DNS (4 records)
### The purpose of setting up both with and without proxy is to provide a development and test environment
### that mimics both proxied and non-proxied conditions. This allows for more comprehensive testing.
### If you're not using Cloudflare, you can simply ignore the proxy (vsp) variable.

# Create vs.yourdomain.dev (without proxy enabled in Cloudflare for a non-proxied environment)
# Create *.vs.yourdomain.dev (also without proxy enabled in Cloudflare for a non-proxied wildcard subdomain)
maindomain='vs.your.dev'

# Create vsp.yourdomain.dev (with proxy enabled for a proxied environment)
# Should be created as an *-alias, e.g., *.vs.yourdomain.dev (with proxy enabled in Cloudflare)
maindomainproxy='vsp.your.dev'


# Standard parameters for Apache and user directories
### Define standard parameters
domain=$1  # The first argument passed to the script, expected to be the domain
owner=$(who am i | awk '{print $1}')  # The user running the script
apacheUser=$(ps -ef | egrep '(httpd|apache2|apache|www-data)' | grep -v root | head -n1 | awk '{print $1}')  # User running the Apache process
email=$gitMail  # Set email to the previously defined Git email, or specify another email here
sitesEnabled='/etc/apache2/sites-enabled/'  # Directory for enabled sites
sitesAvailable='/etc/apache2/sites-available/'  # Directory for available sites
userDir='/var/www/'  # Web root directory

# Root user check
### Are you root?
# Checks if the user running the script is root. If not, exits with an error message.
if [ "$(whoami)" != 'root' ]; then
	echo "You do not have the necessary permissions to run $0 as a non-root user. Use sudo or su."
	exit 1;
fi


# Clear the screen before displaying anything
clear

# Display some colorful ASCII console art and a welcome message
echo -e "\033[1;35m██████╗░░█████╗░██████╗░░█████╗░███╗░░░███╗"
echo -e "\033[1;35m██╔══██╗██╔═══╝░██╔══██╗██╔═══╝░████╗░████║"
echo -e "\033[1;35m██║░░██║██║░░░░░██║░░██║██║░░░░░██╔████╔██║"
echo -e "\033[1;35m██║░░██║██║░░░░░██║░░██║██║░░░░░██║╬██║╬██║"
echo -e "\033[1;35m██████╔╝╚█████╗░██████╔╝╚█████╗░██║░╚██░╚██║"
echo -e "\033[1;35m╚═════╝░░╚════╝░╚═════╝░░╚════╝░╚═╝░░╚═╝░╚═╝\033[0m"
echo -e "\033[0;96m"
echo "######################################################"
echo "#                                                    #"
echo -e "#        \033[1;33mWelcome to Dev Environment 🚀\033[0;96m               #"
echo -e "#             \033[1;33mVersion 1.1.7 ✨\033[0;96m                      #"
echo "#                                                    #"
echo "######################################################"
echo -e "\033[0m"

echo -e "👋 \033[1;92mHey there, developer extraordinaire!\033[0m 👋"
echo -e "\033[0;93mWelcome to DCDCM! 🚀\033[0m"
echo -e "\033[0;94mWhat's DCDCM, you ask? 🤔\033[0m"
echo -e "\033[0;92mIt stands for 'Developer Code Deployment Configuration Master.'\033[0m"
echo -e "\033[0;95mI know, I know... I couldn't find a cool name either, so this is what ChatGPT came up with! 😅\033[0m"
echo -e "🛠  This \033[0;93mscript\033[0m will \033[0;94mguide you\033[0m through setting up a new development environment. 🛠"
echo -e "🌈  Whether you're using \033[1;95mVS Code\033[0m or \033[1;95mJetbrains\033[0m, we've got you covered! 🌈"
echo ""

### Loop to prompt the user for GitHub action: Clone or Create
# This loop will keep running until the user provides a valid input for the variable 'githubAction'
while [ "$githubAction" == "" ]
do

	# Add a cool echo to explain the upcoming question
	echo "#######################################################"
	echo -e "\033[0;33m✨ Time to decide how you want to set up your repository! ✨\033[0m"
	echo -e "\033[0;32mYou can either clone an existing repo or create a new one.\033[0m"
	echo "#######################################################"
	echo ""

	# Display options to the user: (E) for Existing repo to clone or (N) for New repo to create
	echo -e "\033[0;102m E) 🗄️ Existing Repo (Clone from Github)\033[0m or \033[0;101mN) 🎉 New Repo (Create a new Repo on Github) 🥳\033[0m"
	echo ""
	echo "Press [E] or [N]"
	echo ""
	# Read the user's input into the 'githubAction' variable
	read githubAction
done


if [[ $githubAction =~ ^[eE]$ ]]
then

	# Check if the GitHub CLI tool "gh" is installed
	if ! command -v gh &> /dev/null; then
		echo -e "\033[0;31mError: GitHub CLI (gh) is not installed.\033[0m"
		echo -e "\033[0;32mTo install GitHub CLI, follow the instructions at:\033[0m"
		echo -e "\033[0;32m -> https://github.com/cli/cli#installation\033[0m"
		echo ""
		echo -e "⚡ Please install ´gh´ to continue. I will quit the script now, back to you, prompt:"
		echo ""
		exit 1
	fi

	# Display a message indicating that the next action is to clone an existing GitHub repository
	# Text will be bold and blue
	echo -e "\033[1;34mCloning an existing GitHub Repository:\033[0m"

	# Display a message indicating that repositories are being loaded from GitHub
	# Text will be bold and yellow
	echo -e "\033[1;33mLoading your repos from GitHub, please wait...\033[0m"

	# No jq command? Need to install:
	if ! command -v jq &> /dev/null; then
		echo "The 'jq' tool is not installed. Please install it and try again."
		echo "⭐ jq is a small tool to parse JSON in cli, it wont take up much space :)"
		echo "You can install it using 'apt install jq' or 'brew install jq'."
		exit 1
	fi

	# Fetch the GitHub repos and store it in a variable as JSON
	json=$(gh repo list --limit 1000 --json name,visibility,updatedAt)

	# Check if the JSON is empty
	if [[ -z "$json" || "$json" == "[]" ]]; then
	echo -e "\033[0;31mNo repositories found. You may need to login to GitHub.\033[0m"
	echo "Run 'gh auth login' to authenticate your GitHub account and try again."
	exit 1
	fi

	# Declare two arrays: one for the formatted repo details and another for the names
	declare -a repo_array=()
	declare -a name_array=()

	# Populate the arrays
	while IFS=" " read -r name visibility updatedAt; do
	color="\033[0;31m" # Default to red for PRIVATE
	if [ "$visibility" == "PUBLIC" ]; then
		color="\033[0;32m" # Green for PUBLIC
	fi
	repo_array+=("$name\t${color}$visibility\033[0m\t$updatedAt")
	name_array+=("$name")
	done < <(echo "$json" | jq -r '.[] | "\(.name) \(.visibility) \(.updatedAt)"')

	# Display the list and allow user to pick
	echo -e "\033[0;36mPlease select a repo from your GitHub:\033[0m"
	counter=1
	for i in "${repo_array[@]}"; do
	echo -e "$counter) $i"
	counter=$((counter + 1))
	done

	# Read user input
	read -p "🎲 Pick a number: " choice

	# Extract only the domain (repo name) based on user input
	if [[ $choice -ge 1 && $choice -le ${#repo_array[@]} ]]; then
	domain="${name_array[$((choice - 1))]}"
	echo -e "\033[0;32mYou selected the repo named: $domain\033[0m"
	else
	echo -e "\033[0;31mInvalid selection\033[0m"
	fi

	# Concatenate the variables $sitesAvailable and $domain.conf to create the complete path for the available sites
	sitesAvailabledomain=$sitesAvailable$domain.conf

	# If the variable $rootDir is empty, replace it with the value of $domain where each period (.) is removed
	if [ "$rootDir" == "" ]; then
		rootDir=${domain//./}
	fi

	# If the $rootDir variable starts with '/', set $userDir to an empty string 
	# (This is useful if an absolute path is provided for the root directory)
	if [[ "$rootDir" =~ ^/ ]]; then
		userDir=''
	fi

	# Define the root directory by concatenating $userDir and $rootDir
	rootDir=$userDir$rootDir

	# Check if the domain already exists by checking if the configuration file exists
	if [ -e $sitesAvailabledomain ]; then
		echo -e $"🙀 This domain already exists!\n"
		echo -e $"There seems to be a apache2 config for this domain already?.\nPlease Try Another one"
		exit;
	fi


	# Check if the folder (directory) exists
	if ! [ -d $rootDir ]; then

		# Create directories
		mkdir $rootDir
		mkdir $rootDir/$domain

		# Check if the variable intelephenseLicense is defined and not empty
		if [ -n "$intelephenseLicense" ]; then
			# Create the 'intelephense' directory
			mkdir $rootDir/intelephense
			
			# Create a license file and populate it with the value in $intelephenseLicense
			echo "$intelephenseLicense" > $rootDir/intelephense/license.txt
		fi
		
		# Clone the GitHub repo
		gh repo clone $gitUsername/$domain $rootDir/$domain
		
		# Set permissions
		chmod 755 $rootDir
		chown -R $ownerUsername:$ownerGroup $rootDir
		chgrp -R $ownerGroup $rootDir
		
		# Create Apache2 Virtual Host configuration
		if ! echo "
			<VirtualHost *:80>
				ServerAdmin $email
				ServerName $domain.$maindomain
				ServerAlias $domain.$maindomainproxy
				DocumentRoot $rootDir/$domain
				<Directory />
					AllowOverride All
				</Directory>
				<Directory $rootDir>
					Options Indexes FollowSymLinks MultiViews
					AllowOverride all
					Require all granted
				</Directory>
				ErrorLog /var/log/apache2/$domain-error.log
				LogLevel error
				CustomLog /var/log/apache2/$domain-access.log combined
			</VirtualHost>" > $sitesAvailabledomain
		then
			echo -e $"Error: Could not create Apache2 config for $domain"
			exit;
		else
			echo -e $"\nNew virtual host created in Apache2\n"
		fi
		
		# Add domain to /etc/hosts
		if ! echo "127.0.0.1  $domain.$maindomain" >> /etc/hosts
		then
			echo $"ERROR: Not able to write in /etc/hosts"
			exit;
		else
			echo -e $"$domain.$maindomain added to /etc/hosts file\n"
		fi
		
		# Enable the Apache site
		a2ensite $domain
		
		# Reload Apache to apply changes
		/etc/init.d/apache2 reload
		
		# Generate SSL certificate
		/usr/bin/certbot --apache --non-interactive --agree-tos -m $email -d $domain.$maindomain
		
		# Setup Git username and email
		# Deprecated, now I use 1 user for every site, not a unique user per project
		#su -c "git config --global user.email $gitmail" $domain
		#su -c "git config --global user.name $gitname" $domain
		
		# Display completion messages
		# Display completion messages
		echo -e "\033[0;102m Woohoo! 🥳 Your VS Code Dev. Env. is ready to rock! 🎸\033[0m"
		echo -e "\033[0;105m Virtual Host URL: https://$domain.$maindomain 🌐\033[0m"
		echo -e "\033[0;105m Virtual Host Proxy URL: https://$domain.$maindomainproxy 🛡️🌐\033[0m"
		echo -e "\033[0;103m Connect to your server from VS Code using the Remote SSH plugin ⚙️\033[0m"
		echo -e "\033[0;103m Read more at https://code.visualstudio.com/docs/remote/ssh\033[0m"
		echo -e "\033[0m "
		echo -e "=== END 🚀 ==="

		
		# Exit the script
		exit;
	fi


    exit 1
fi

if [[ $githubAction =~ ^[nN]$ ]]
then

	# Display a beautiful welcome message
	echo -e "\033[0;102m 🌟 Welcome to the Git Repo Creator Wizard! 🌟 \033[0m"
	echo -e "\033[0;105m Let's set up your next awesome GitHub repository! 🚀 \033[0m"

	# Selector for repo visibility
	echo -e "\033[0;103m 🤔 What type of repository would you like to create? \033[0m"
	echo -e "\033[0;33m 1) Private Repo 🕵️‍♂️"
	echo -e "\033[0;33m 2) Public Repo 🌍\033[0m"

	# Read user choice
	read -p "🎲 Make your choice (1 or 2): " choice

	# Set the variable $repoStatus based on the choice
	case $choice in
	1)
		repoStatus='--private'
		echo -e "\033[0;32m 🛡️ Great, your repo will be Private! 🛡️ \033[0m"
		;;
	2)
		repoStatus='--public'
		echo -e "\033[0;32m 🌐 Awesome, your repo will be Public! 🌐 \033[0m"
		;;
	*)
		echo -e "\033[0;31m 😞 Invalid choice. Exiting. 😞 \033[0m"
		exit 1
		;;
	esac

	# Function to check if a string contains only alphanumeric characters, dashes, and underscores
	is_valid_github_repo_name() {
	local str="$1"
	for (( i=0; i<${#str}; i++ )); do
		local c="${str:i:1}"
		ascii=$(printf '%d' "'$c")
		if [[ ( $ascii -lt 48 ) || ( $ascii -gt 57 && $ascii -lt 65 ) || ( $ascii -gt 90 && $ascii -lt 97 ) || ( $ascii -gt 122 ) ]] && [[ "$c" != "-" && "$c" != "_" && "$c" != "." ]]; then
		return 1
		fi
	done
	return 0
	}

	# Loop to ensure the user enters a valid name for the new repo
	while true; do
	echo -e "\033[0;96m 🤓 What's the name of your new awesome repo? (e.g., project-dev) 🚀\033[0m"
	read -p "🎤 Your New Repo Name [a-zA-Z0-9._-] -> $gitUsername/" domain

	if is_valid_github_repo_name "$domain"; then
		echo -e "\033[0;92m 🎉 Fantastic, the new repository will be named: $domain! 🎉\033[0m"
		break
	else
		echo -e "\033[0;91m 😬 Oops! That name won't work. GitHub repo names can only contain alphanumeric characters, dashes, and underscores. 😬\033[0m"
	fi
	done


exit 1;

	
	# Concatenate the variables $sitesAvailable and $domain.conf to create the complete path for the available sites
	sitesAvailabledomain=$sitesAvailable$domain.conf

	# If the variable $rootDir is empty, replace it with the value of $domain where each period (.) is removed
	if [ "$rootDir" == "" ]; then
		rootDir=${domain//./}
	fi

	# If the $rootDir variable starts with '/', set $userDir to an empty string 
	# (This is useful if an absolute path is provided for the root directory)
	if [[ "$rootDir" =~ ^/ ]]; then
		userDir=''
	fi

	# Define the root directory by concatenating $userDir and $rootDir
	rootDir=$userDir$rootDir

	# Check if the domain already exists by checking if the configuration file exists
	if [ -e $sitesAvailabledomain ]; then
		echo -e $"🙀 This domain already exists!\n"
		echo -e $"There seems to be a apache2 config for this domain already?.\nPlease Try Another one"
		exit;
	fi

	### check om mappe eksiserer
	if ! [ -d $rootDir ]; then
		
		# Create directories
		mkdir $rootDir
		mkdir $rootDir/$domain

		# Check if the variable intelephenseLicense is defined and not empty
		if [ -n "$intelephenseLicense" ]; then
			# Create the 'intelephense' directory
			mkdir $rootDir/intelephense
			
			# Create a license file and populate it with the value in $intelephenseLicense
			echo "$intelephenseLicense" > $rootDir/intelephense/license.txt
		fi


		git -C "$rootDir/$domain" init

		cd $rootDir/$domain
		cd $rootDir/$domain && gh repo create $domain --add-readme $repoStatus --confirm

		# Set permissions
		chmod 755 $rootDir
		chown -R $ownerUsername:$ownerGroup $rootDir
		chgrp -R $ownerGroup $rootDir
		
		if ! echo "
			<VirtualHost *:80>
				ServerAdmin $email
				ServerName $domain.$maindomain
				ServerAlias $domain.$maindomainproxy
				DocumentRoot $rootDir/$domain
				<Directory />
					AllowOverride All
				</Directory>
				<Directory $rootDir>
					Options Indexes FollowSymLinks MultiViews
					AllowOverride all
					Require all granted
				</Directory>
				ErrorLog /var/log/apache2/$domain-error.log
				LogLevel error
				CustomLog /var/log/apache2/$domain-access.log combined
			</VirtualHost>" > $sitesAvailabledomain
		then
			echo -e $"Error: Could not create Apache2 config for $domain"
			exit;
		else
			echo -e $"\nNew virtual host created in Apache2\n"
		fi
		
		# Add domain to /etc/hosts
		if ! echo "127.0.0.1  $domain.$maindomain" >> /etc/hosts
		then
			echo $"ERROR: Not able to write in /etc/hosts"
			exit;
		else
			echo -e $"$domain.$maindomain added to /etc/hosts file\n"
		fi
		
		# Enable the Apache site
		a2ensite $domain
		
		# Reload Apache to apply changes
		/etc/init.d/apache2 reload
		
		# Generate SSL certificate
		/usr/bin/certbot --apache --non-interactive --agree-tos -m $email -d $domain.$maindomain

		### show the finished message
		echo -e "\033[0;102m Woohoo! 🥳 Your VS Code Dev. Env. is ready to rock! 🎸\033[0m"
		echo -e "\033[0;105m Virtual Host URL: https://$domain.$maindomain 🌐\033[0m"
		echo -e "\033[0;105m Virtual Host Proxy URL: https://$domain.$maindomainproxy 🛡️🌐\033[0m"
		echo -e "\033[0;103m Connect to your server from VS Code using the Remote SSH plugin ⚙️\033[0m"
		echo -e "\033[0;103m Read more at https://code.visualstudio.com/docs/remote/ssh\033[0m"
		echo -e "\033[0m "
		echo -e "=== END 🚀 ==="

		exit;
	
	fi

    exit 1
fi

exit;
