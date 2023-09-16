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

<img width="1122" alt="danielbahl-2023-09-16-011683@2x" src="https://github.com/danielbahl/DCDCM/assets/628182/256bef60-2c10-4dbf-a44e-a5ce140b7399">

## Features ✨

- **Apache2 Setup**: Auto-configures Apache2 for your dev environments.
- **Git Integration**: Either clones an existing repo or initializes a new one.
- **Let's Encrypt**: Sets up SSL for your environments.
- **VS Code** and **PhpStorm/WebStorm** Compatible: Seamlessly use this in go-to IDE to host all your dev environments on a remote cloud server.

## Remote SSH Projects in VS Code 🌍

### The What and Why of Remote SSH 🤷‍♂️

One of the powerful features that VS Code offers is the ability to code on your local machine but have all of the code run and be stored on a remote server. This feature is known as Remote SSH. But why would you need this?

- **Hardware Limitations**: Your local machine may not be powerful enough to run all the services you need, but your cloud server can handle it like a breeze.
- **24/7 Access**: You dev. env. is on 24/7 making it easy to share links to a test-project with a customer or coworkers, without having the hassle of port forwards, and making sure the project is running on your computer, all the time.
- **Every Device**: With Remote Hosted Code you can work from your iPhone or iPad.
- **Isolation**: Keep your development environment isolated from your local machine.
- **Multiple Developers**: Makes it easier for multiple developers to collaborate on the same project in real-time.
- **~Cheaper~MUCH CHEAPER than CodeSpaces**: I love GitHub CodeSpaces, but my monthly bill (50-65$/mo.) was just too much 💸 So I decided to create my own self-hosted Dev. Env. with a Cloudserver from Hippoways.com. Now I pay just $10 for a powerful Linux server with everything included.
- **Static IP**: CodeSpaces = New IP every day. Own Server = Static IP, making it easier to whitelist remote DB connections etc.

### Setting It Up 🔧

1. **Install Remote - SSH Extension**: The first step is to install the [Remote - SSH extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) from the VS Code marketplace.
   
2. **Configure SSH Keys**: If you haven't already, you'll need to set up SSH keys. Open your terminal and run:
    ```bash
    ssh-keygen -t rsa -b 4096
    ```
    This will generate a new SSH key, using the provided email as a label.

3. **Adding your SSH key to the ssh-agent**: Run the following commands to add your SSH key to the ssh-agent.
    ```bash
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    ```
   
4. **Connect to Remote Server**: Open VS Code, then open the command palette (`F1` or `Ctrl+Shift+P`) and type `Remote-SSH: Connect to Host`. Select the configured server from the list, and VS Code will connect to it.

5. **Start Coding**: Once connected, your VS Code window will reload and clone the UI of the remote server. You can start editing files, running programs, and much more, all as if you were doing it locally.

### How It Fits with Our Apache2 Dev Environment Creator 🤝

Once you've set up your development environment using our Apache2 Dev Environment Creator script, you can easily connect to it using VS Code's Remote SSH feature. All the variables and settings you configured will be available to you remotely. This integration makes it a breeze to develop in a stable, isolated, yet powerful environment, without any of the setup hassles.

So go ahead, combine the power of Apache2 Dev Environment Creator with VS Code Remote SSH and take your development workflow to the next level! 🚀

## How to Use in VS Code 🛠

This script is highly compatible with VS Code. Here's how you can use it:

1. Open the terminal in VS Code.
2. SSH into your remote cloud server where you wish to set up the environment.
3. Run the script.

Boom! Your dev environment is not just set up, but it's also ready for remote access and development via VS Code!

@TODO **Write a blog-post on piraffe.com about this stuff** and how I went all-remote in my dev-setup without paying 45-50$ / mo. for GitHub Codespaces / Gitpod / IDX etc.

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

## Oh, and I creafted a Delete Script as well:

![danielbahl-2023-09-16-011682@2x](https://github.com/danielbahl/DCDCM/assets/628182/bfe4fd4c-9fff-47ab-9692-f16b24c4e794)

---
Crafted with ❤️ and a sprinkle of 🌶️ by [Daniel Bahl](https://github.com/danielbahl). Enjoy and happy coding! 🚀
