#!/bin/zsh

set -e

echo "Setup Python libraries..."
pip3 install "erlport>=0.6"
pip3 install "ephem>=4.1,<5.0"
