#!/bin/bash

# Function to check if a website is behind a load balancer
check_load_balancer() {
    website=$1

    headers=$(curl -I -s $website)

    if echo "$headers" | grep -q "X-Load-Balancer"; then
        echo "The website $website is behind a load balancer"
        return
    elif echo "$headers" | grep -q "Server: AWSALB"; then
        echo "The website $website is behind an AWS Application Load Balancer"
        return
    elif echo "$headers" | grep -q "Server: AWSELB"; then
        echo "The website $website is behind an AWS Classic Load Balancer"
        return
    elif echo "$headers" | grep -q "Server: ALB"; then
        echo "The website $website is behind an Azure Load Balancer"
        return
    elif echo "$headers" | grep -q "Server: GCLB"; then
        echo "The website $website is behind a Google Cloud Load Balancer"
        return
    elif echo "$headers" | grep -q "Server: ELB"; then
        echo "The website $website is behind an Elastic Load Balancer"
        return
    elif echo "$headers" | grep -q "Server: Haproxy"; then
        echo "The website $website is behind a HAProxy Load Balancer"
        return
    fi

    # Additional load balancer checks can be added here

    echo "The website $website is not behind a known load balancer"
}

# Function to check which firewall is running in a web application
check_firewall() {
    website=$1

    headers=$(curl -I -s $website)

    server_header=$(echo "$headers" | grep "Server:" | awk '{print $2}')

    if echo "$server_header" | grep -qi "Cloudflare"; then
        echo "The website $website is protected by Cloudflare firewall"
    elif echo "$server_header" | grep -qi "Incapsula"; then
        echo "The website $website is protected by Incapsula firewall"
    elif echo "$server_header" | grep -qi "Akamai"; then
        echo "The website $website is protected by Akamai firewall"
    elif echo "$server_header" | grep -qi "Sucuri"; then
        echo "The website $website is protected by Sucuri firewall"
    elif echo "$server_header" | grep -qi "Barracuda"; then
        echo "The website $website is protected by Barracuda firewall"
    else
        echo "The website $website is not protected by a known firewall"
    fi
}

# Function to print the banner
print_banner() {
    figlet -c -f slant "LBC"
    echo -e "\e[32mLOAD BALANCER CHECKER\e[0m"
}

# Print the banner
print_banner

# Read the website URLs from user
echo "Enter the website URLs (or multiple URLs separated by space): "
read -r websites

# Split the entered websites into an array
IFS=' ' read -ra website_array <<< "$websites"

# Loop through each website in the array
for website in "${website_array[@]}"; do
    echo "Checking website: $website"
    echo "-------------------------"

    # Call the check_load_balancer function to check if the website is behind a load balancer
    check_load_balancer "$website"

    echo

    # Call the check_firewall function to check which firewall is running in the web application
    check_firewall "$website"

    echo "-------------------------"
    echo

done
