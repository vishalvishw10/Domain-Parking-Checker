#!/bin/bash


command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but not installed. Aborting."; exit 1; }
command -v grep >/dev/null 2>&1 || { echo >&2 "grep is required but not installed. Aborting."; exit 1; }

check_parked() {
    local domain="$1"
    local response=$(curl -s -L "$domain")  # Follow redirects with -L option

    if echo "$response" | grep -iq "parked"; then
        echo "$domain is parked."
        echo "$domain is parked." >> results.txt
    else
        echo "$domain is not parked."
        echo "$domain is not parked." >> results.txt
    fi
}

read -p "Enter the path to the input file containing the list of domains: " input_file

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file not found."
    exit 1
fi

readarray -t domains < "$input_file"

echo "Results:" > results.txt
for domain in "${domains[@]}"; do
    check_parked "$domain"
done

echo "Results saved to results.txt"
