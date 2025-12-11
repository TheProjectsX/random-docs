# VPS Setup for MERN Stack

## One Click Installation
Below scripts can do the whole manual work automatically. Used Bash to Create it. 
### Setup VPS
``` bash
```
Or you can also copy paste [this file](./setup/setup.sh) in your VPS and run Manually.

### Create Nginx Configuration
``` bash
```
Or you can also copy paste [this file](./setup/nginx.sh) in your VPS and run Manually.


## Login to VPS

You will have an VPS IP Address, Username and Password.

-   To Login to VPS, open any Command Shell (CMD for Windows, Terminal for Ubuntu).
-   Type and Enter:

```bash
ssh root@0.0.0.0
# Here ssh is connecting us to out VPS
# root is Username
# 0.0.0.0 is Your VPS IP address
```

-   After that, if asks for any confirmation, type `yes` and hit enter.
-   Then it will ask for Password, type of paste your password and hit enter.
-   NOTE: The password won't be visible.
You can also use some SSH Host manager like Termius

## Install Zsh

### Download and Setup zsh and plugins

```bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install zsh git curl -y

# Make zsh your default shell
chsh -s $(which zsh)

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Update zshrc with Custom configuration

-   Has `robbyrussell` as terminal theme
-   Has syntax highlighting and auto suggestions plugin
-   Has exported paths for `NVM` and `NVM bash completion`

```bash
mv ~/.zshrc ~/.zshrc.bak # Remove auto generated zsh config (we are renaming it to a bak file)
nano .zshrc
```

Paste the [.zshrc config](./files/zshrc) in the editor and type `ctrl + x -> ctrl + y`. Type `source .zshrc` to restart zsh or exit and restart the ssh.

## Install NVM and NodeJS

### Install NVM

Copy installation command `curl` from [NVM GitHub Repo](https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script) and run in the terminal.

### Restart zsh shell

```bash
source ~/.zshrc
```

### Install Node

```bash
# Check if NVM installed
nvm -v


# Install LTS version of node (recommended version)
nvm install --lts


# Check if node is installed
node -v
```

## Install MongoDB

### Check your Ubuntu version and Codename

```bash
lsb_release -a
```

### Install

Select Distribution and Codename and use the Commands [1-4] to Install VPS specific version from [Official MongoDB](https://www.mongodb.com/docs/manual/administration/install-community/?linux-distribution=ubuntu&linux-package=default&operating-system=linux&search-linux=with-search-linux#install-mongodb-community-edition-18)

### Start Service and Check

```bash
sudo systemctl start mongod
sudo systemctl enable mongod

# Check
mongosh
```

### Enable Replica set

-   Stop MongoDB Service

```bash
sudo systemctl stop mongod
```

-   Edit MongoDB Config

```bash
nano /etc/mongod.conf
```

-   Paste the Below yaml in the top level

```yaml
replication:
    replSetName: "rs0"
```

-   Start MongoDB

```bash
sudo systemctl start mongod
```

-   Initialize and check Replica set

```bash
mongosh

# In mongo shell:
rs.initiate()
rs.status()
```

## System Configurations

### Generate GitHub SSH Key

```bash
# Generate SSH Key. In case of stuck, type 'y' and enter
ssh-keygen -t rsa -b 4096 -C "email@example.com"

# Turn on the SSH Key
eval "$(ssh-agent -s)"

# View the SSH Key
cat ~/.ssh/id_rsa.pub

# Test the Connection
ssh -T git@github.com
```

### Enable Uncomplicated Firewall (UFW)

```bash
# Enable
sudo ufw enable

# Allow SSH port (MUST). Same command applies for any other port
sudo ufw allow ssh

# Deny any port if needed
sudo ufw deny PORT

# Reload After allowing / denying any port
sudo ufw reload

# Check status
sudo ufw status
```

### Install pm2

`pm2` (Process Manager 2) is a popular process manager for Node.js applications. It is used to manage and monitor Node.js applications, ensuring they run reliably in production environments.

```bash
# Install
npm i -g pm2

# Start an Application
pm2 start "npm run start" --name "test_server"

# List processes
pm2 ls

# Show logs
pm2 logs [process number or name]

# Restart process
pm2 restart [process number or name]

# Stop process
pm2 stop [process number or name]
```

### Install Nginx

```bash
sudo apt install nginx

# Update ufw
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
```

-   Nginx files are located in `/etc/nginx` directory.
-   You can use `conf.d` directory to add project configurations to nginx
-   [Follow this config](./files/nginx.conf)
-   NOTE: It's better to name your conf's with the domain name: `website.com.conf` / `api.website.com.conf`

```bash
# Check Configurations
sudo nginx -t

sudo systemctl restart nginx
```

### Use certbot for SSL (https)

```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx

# To install certificate to your domain you can use this command:
sudo certbot --nginx -d website.com -d www.website.com
# you can also use "sudo certbot --nginx -d website.com" but since we have "www"
# too we are passing another argument with another website.

# When you do it for first time, it will ask for email, enter any email.
# Then it will tell to agree to conditions or whatever, choose "Y"
# At last, it will tell if you want to share your email, choose "n"

# Now, let's do for our api one
sudo certbot --nginx -d api.website.com -d www.api.website.com
```
