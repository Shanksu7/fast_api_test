#!/bin/bash

# Send a notification to Discord indicating the app is starting
curl -H "Content-Type: application/json" -X POST -d '{"content":"Starting FastAPI app deployment..."}' "https://discord.com/api/webhooks/1328763919363477524/CnA6ZInh1EtZlu8oXp3kfFhjAb_uqViic8TfLNbmrjwHXPkOmkm9ZkM6JRGh7-Hc4Y2H"

# Install any pre-install dependencies
echo "Running pre-install script..."
pip install -r preinstall-requirements.txt

# Start the FastAPI app with Gunicorn
echo "Starting FastAPI app..."
exec gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app
