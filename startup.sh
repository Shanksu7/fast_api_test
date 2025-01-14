#!/bin/bash

# Function to send message to Discord
send_to_discord() {
    local message=$1
    curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"$message\"}" "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"
}

# Send initial notification to Discord
send_to_discord "Starting FastAPI app deployment... Pre-Installing requirements"

# Set up virtual environment
echo "Setting up virtual environment..."
send_to_discord "Setting up virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install pre-install requirements (and capture output)
echo "Installing pre-install requirements..."
send_to_discord "Installing pre-install requirements..."
pip install -r preinstall-requirements.txt 2>&1 | tee preinstall_output.log
send_to_discord "$(cat preinstall_output.log)"

# Send Discord notification about installing main requirements
echo "Installing main requirements..."
send_to_discord "Installing main requirements..."
pip install -r requirements.txt 2>&1 | tee requirements_output.log
send_to_discord "$(cat requirements_output.log)"

# Run setup script (and capture output)
echo "Running setup script..."
send_to_discord "Running setup script..."
python setup_script.py 2>&1 | tee setup_output.log
send_to_discord "$(cat setup_output.log)"

# Send Discord notification about app start
echo "Starting FastAPI app..."
send_to_discord "Starting FastAPI app..."

# Start the FastAPI app with Gunicorn and capture output
exec gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app 2>&1 | tee gunicorn_output.log
send_to_discord "$(cat gunicorn_output.log)"
