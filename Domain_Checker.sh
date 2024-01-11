#!/bin/bash

# Check if the required commands are available
command -v dig >/dev/null 2>&1 || { echo >&2 "dig is required but not installed. Aborting."; exit 1; }

# Keywords for identifying parked domains
keywords="godaddy|is for sale|domain parking|renew now|this domain|namecheap|buy now for|hugedomains|is owned and listed by|sav.com|searchvity.com|domain for sale|register4less|aplus.net|related searches|related links|search ads|domain expert|united domains|domain name has been registered|this domain may be for sale|domain name is available for sale|premium domain|this domain name|this domain has expired|domainpage.io|sedoparking.com|parking-lander"

# Function to check if a domain is parked
check_parked() {
    local domain="$1"
    
    # Use dig to check if the domain has an A record
    if dig +short "$domain" >/dev/null 2>&1; then
        # Fetch webpage content
        local response=$(curl -s -L "http://$domain")
        
        # Check for parked domain keywords
        if echo "$response" | grep -iqE "$keywords"; then
            echo "$domain,Parked"
        else
            echo "$domain,Live"
        fi
    else
        echo "$domain,Not Live"
    fi
}

# Prompt user for the input file
read -p "Enter the path to the input file containing the list of domains: " input_file

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file not found."
    exit 1
fi

# Read domains from the input file
while IFS= read -r domain; do
    check_parked "$domain"
done < "$input_file" > results.csv

echo "Results saved to results.csv"
