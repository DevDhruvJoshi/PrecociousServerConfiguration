#!/bin/bash

# Exit script on any error
set -e

# Function to display messages
function echo_msg() {
    echo ">>> $1"
}

# Function to display error messages in red
function echo_error() {
    echo -e "\033[31m>>> ERROR: $1\033[0m"
}

# Function to validate domain
function validate_domain() {
    local domain="$1"
    if [[ ! "$domain" =~ ^[a-zA-Z0-9.-]+$ ]]; then
        echo_error "Invalid domain name. Please enter a valid domain (e.g., example.com)."
        return 1
    fi
    return 0
}

# Function to check if the domain points to the server's IP
function check_dns() {
    local domain="$1"
    local server_ip=$(hostname -I | awk '{print $1}') # Get the server's first IP
    local dns_ip=$(dig +short "$domain" A | head -n 1) # Get the A record for the domain

    if [[ "$dns_ip" != "$server_ip" ]]; then
        echo_error "The domain '$domain' does not point to this server's IP ($server_ip)."
        echo "Please update the DNS A record for '$domain' to point to this server's IP."
        echo_msg "Continuing with installation despite DNS issues."
    fi
}

# Function to install Nginx
function handle_nginx() {
    if command -v nginx &> /dev/null; then
        echo_msg "Nginx is already installed."
        if sudo systemctl is-active --quiet nginx; then
            echo_msg "Stopping Nginx temporarily..."
            sudo systemctl stop nginx
        fi
    else
        echo_msg "Installing Nginx..."
        if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
            sudo apt install nginx -y
        else
            sudo yum install nginx -y
        fi
        echo_msg "Starting Nginx..."
        sudo systemctl start nginx
        sudo systemctl enable nginx
    fi
}

# Prompt for domain name
while true; do
    read -p "Enter your domain name (default: app.example.com): " DOMAIN
    DOMAIN=${DOMAIN:-app.example.com}

    if validate_domain "$DOMAIN"; then
        break
    fi
done

# Check if the domain points to this server's IP
check_dns "$DOMAIN"

# Determine package manager
if command -v apt &> /dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v yum &> /dev/null; then
    PACKAGE_MANAGER="yum"
elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
else
    echo_error "No supported package manager found (apt, yum, dnf). Exiting."
    exit 1
fi

# Check if it's a new server
NEW_SERVER="y"  # Default to yes
if [[ "$NEW_SERVER" =~ ^[yY]$ ]]; then
    echo_msg "Updating package list..."
    sudo $PACKAGE_MANAGER update -y

    # Install Git
    echo_msg "Installing Git..."
    if ! command -v git &> /dev/null; then
        sudo $PACKAGE_MANAGER install git -y
    else
        echo_msg "Git is already installed."
    fi

    # Install Apache
    echo_msg "Installing Apache..."
    if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo ufw allow 'Apache Full'
    else
        sudo yum install httpd -y
        sudo systemctl start httpd
        sudo systemctl enable httpd
    fi

    # Handle Nginx
    handle_nginx

    # Install PHP and required extensions
    echo_msg "Installing PHP and extensions..."
    if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo add-apt-repository ppa:ondrej/php -y
        sudo apt update -y
        sudo apt install -y php libapache2-mod-php php-mysql php-fpm \
        php-curl php-gd php-mbstring php-xml php-zip php-bcmath php-json
    else
        sudo yum install php php-mysqlnd php-fpm php-curl php-gd php-mbstring php-xml php-zip php-bcmath -y
    fi

    # Enable PHP module and configuration
    if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo a2enmod php8.3
        sudo a2enconf php8.3-fpm
    fi

    # Restart Apache to apply changes
    echo_msg "Restarting Apache..."
    sudo systemctl restart apache2 || sudo systemctl restart httpd

    # Install MySQL server
    echo_msg "Installing MySQL server..."
    sudo $PACKAGE_MANAGER install mysql-server -y
    echo_msg "Please run 'mysql_secure_installation' manually to secure your MySQL installation."

    # Enable Apache rewrite module
    echo_msg "Enabling Apache rewrite module..."
    if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo a2enmod rewrite
    fi
    sudo systemctl restart apache2 || sudo systemctl restart httpd
fi

# Create directories for virtual hosts
echo_msg "Creating directories for virtual hosts..."
sudo mkdir -p /var/www/$DOMAIN

# Clone the Git repository
echo_msg "Cloning the Git repository..."
git clone git@github.com:DevDhruvJoshi/Precocious.git /var/www/$DOMAIN

# Create virtual host configuration files
echo_msg "Creating virtual host configuration files..."
cat <<EOF | sudo tee /etc/apache2/sites-available/$DOMAIN.conf
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias *.$DOMAIN
    DocumentRoot /var/www/$DOMAIN
    <D
