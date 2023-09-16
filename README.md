# Apache2 Dev Environment Creator 🚀

## Description 📝

Welcome to the Apache2 Dev Environment Creator script! 🥳 This script is your one-stop solution for automating the setup of your Apache2 development environments. No more manual configurations! Run a single command and boom 💥, your environment is up and running!

```bash
echo -e "👋 \033[1;92mHey there, developer extraordinaire!\033[0m 👋"
echo -e "\033[0;93mWelcome to DCDCM! 🚀\033[0m"
echo -e "\033[0;94mWhat's DCDCM, you ask? 🤔\033[0m"
echo -e "\033[0;92mIt stands for 'Developer Code Deployment Configuration Master.'\033[0m"
echo -e "\033[0;95mI know, I know... I couldn't find a cool name either, so this is what ChatGPT came up with! 😅\033[0m"
echo ""
```

## Features ✨

- **Apache2 Setup**: Auto-configures Apache2 for your dev environments.
- **Git Integration**: Either clones an existing repo or initializes a new one.
- **Let's Encrypt**: Sets up SSL for your environments.
- **VS Code** and **PhpStorm/WebStorm** Compatible**: Seamlessly use this in go-to IDE to host all your dev environments on a remote cloud server.

## How to Use in VS Code 🛠

This script is highly compatible with VS Code. Here's how you can use it:

1. Open the terminal in VS Code.
2. SSH into your remote cloud server where you wish to set up the environment.
3. Run the script.

Boom! Your dev environment is not just set up, but it's also ready for remote access and development via VS Code!

@TODO Write a blot post on piraffe.com about this stuff and how I went all-remote in my dev-setup without paying 45-50$ / mo. for GitHub Codespaces / Gitpod / IDX etc.

## Editing Variables 🔧

### Git-Related Variables

```bash
gitName='Daniel Bahl'  # Your Git username
gitMail='me@daniel****.com'  # Your Git email
gitUsername='danielbahl'  # Your GitHub or other Git platform username
```

### Software Licenses
```bash
intelephenseLicense='' # If you have an Intelephense license, paste it here
```

### Username and Group
```bash
ownerUsername='piraffe'
ownerGroup='webmasters'
```

### Cloudflare DNS

```bash
maindomain='vs.some.dev'  # Non-proxied main domain
maindomainproxy='vsp.some.dev'  # Proxied main domain
```

### Standard Apache and User Directories

```bash
domain=$1  
owner=$(who am i | awk '{print $1}')
sitesEnabled='/etc/apache2/sites-enabled/'  
sitesAvailable='/etc/apache2/sites-available/'
userDir='/var/www/'  
```

## Installation & Getting Started 🚀

To get started, you'll need to install `gh` and `jq`. Follow the installation instructions for your specific OS.

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install jq # simple command line json parser
sudo apt install gh # https://github.com/cli/cli#installation
```

### Getting Started

1. Clone this repository.
    ```bash
    git clone https://github.com/danielbahl/DCDCM.git
    ```
2. Navigate into the directory.
    ```bash
    cd DCDCM
    ```
3. Run the script.
    ```bash
    sudo bash create-env.sh
    ```

And there you have it! Your Apache2 dev environment is set up! Ready to rock with SSL, New or Cloned Git Repo + much more! 🎉

---
Crafted with ❤️ and a sprinkle of 🌶️ by [Daniel Bahl](https://github.com/danielbahl). Enjoy and happy coding! 🚀
