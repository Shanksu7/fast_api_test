#!/bin/bash

# Function to send a message to Discord
escape_message() {
    echo "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/$/\\n/g'
}

# Function to send message to Discord with escaped content
send_to_discord() {
    local message=$(escape_message "$1")
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\":\"$message\"}" \
         "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"
}

# Ensure jq is available
if ! command -v jq &>/dev/null; then
    send_to_discord "jq is required but not installed. Installing jq..."
    echo "jq is required but not installed. Installing jq..."
    apt-get update && apt-get install -y jq
fi

# Send initial notification to Discord
send_to_discord "Starting FastAPI app deployment... Pre-Installing requirements"

# Get and send the current folder path to Discord
current_folder=$(pwd)
send_to_discord "Current folder: $current_folder"

# Set up virtual environment
#echo "Setting up virtual environment..."
#send_to_discord "Setting up virtual environment..."
#python3 -m venv venv
#source venv/bin/activate

#cd app

# Install pre-install requirements (capture output)
echo "Installing pre-install requirements..."
send_to_discord "Installing pre-install requirements..."
preinstall_output=$(pip install -r preinstall-requirements.txt 2>&1)
send_to_discord "$preinstall_output"

# Install main requirements (capture output)
echo "Installing main requirements..."
send_to_discord "Installing main requirements..."
requirements_output=$(pip install -r requirements.txt 2>&1)
send_to_discord "$requirements_output"

# Run setup script (capture output)
echo "Running setup script..."
send_to_discord "Running setup script..."
setup_output=$(python setup_script.py 2>&1)
send_to_discord "$setup_output"

# Start the FastAPI app with Gunicorn (capture output)
#echo "Starting FastAPI app..."
#send_to_discord "Starting FastAPI app..."
#gunicorn_output=$(exec gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.application:app 2>&1)
#send_to_discord "$gunicorn_output"
