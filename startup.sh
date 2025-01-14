#!/bin/bash

# Function to send a message to Discord
escape_message() {
    echo "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/$/\\n/g'
}

# Function to send message to Discord with escaped content
send_to_discord() {
    local message=$(escape_message "$1")
    current_folder=$(pwd)
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\":\"$current_folder : $message\"}" \
         "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"
}

send_to_discord "Installing apt list"
echo -e "deb http://archive.debian.org/debian stretch main contrib non-free\ndeb http://archive.debian.org/debian-security stretch/updates main contrib non-free" | tee /etc/apt/sources.list > /dev/null
apt-get update

send_to_discord "Installing Git"
apt-get install -y git

send_to_discord "Cloning repo https://github.com/Shanksu7/fast_api_test into folder app..."
git clone https://github.com/Shanksu7/fast_api_test app

cd app
git pull

# Send initial notification to Discord
send_to_discord "Starting FastAPI app deployment... Pre-Installing requirements"

# Get and send the current folder path to Discord
current_folder=$(pwd)
send_to_discord "Current folder: $current_folder"

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

echo "Moving to /home/site/wwwroot/..."
send_to_discord "Moving to /home/site/wwwroot/..."
mv /home/site/wwwroot/app/* /home/site/wwwroot/
cd /home/site/wwwroot/
rm -r app
chmod -x startup.sh
# Start the FastAPI app with Gunicorn (capture output)
echo "Starting FastAPI app..."
send_to_discord "Starting FastAPI app..."
exec gunicorn -w 2 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000 application:app
send_to_discord "Finished"