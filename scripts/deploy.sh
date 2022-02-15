#!/usr/bin/env bash

echo ""
echo "Pushing changes..."
echo "--------------------------"
rsync -avz . mirage@inhji.de:/opt/mirage2 --progress --delete --exclude-from .rsyncignore

echo ""
echo "Building and restarting!"
echo "--------------------------"
ssh -T mirage@inhji.de << EOSSH
cd /opt/mirage2
./scripts/build.sh
sudo systemctl restart mirage2
EOSSH