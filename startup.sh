#!/bin/bash
curl -H "Content-Type: application/json" -X POST -d '{"content":"Starting FastAPI app deployment...\nPre-Installing requirements"}' "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"

# Install pre-install requirements (if needed)
echo "Installing pre-install requirements..."
pip install -r preinstall-requirements.txt

curl -H "Content-Type: application/json" -X POST -d '{"content":"Installing requirements"}' "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"
# Install main requirements
echo "Installing main requirements..."
pip install -r requirements.txt

curl -H "Content-Type: application/json" -X POST -d '{"content":"Running Setup script"}' "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"
# Run setup script (if you have any setup actions)
echo "Running setup script..."
python setup_script.py

# Notify via Discord (optional)
echo "Sending Discord notification..."
curl -H "Content-Type: application/json" -X POST -d '{"content":"Starting FastAPI app deployment..."}' "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"

# Start the FastAPI app with Gunicorn
echo "Starting FastAPI app..."
exec gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app
