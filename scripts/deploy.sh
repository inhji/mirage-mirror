#!/usr/bin/env bash

echo ""
echo "Pushing changes..."
echo "--------------------------"
rsync -avz . mirage@inhji.de:/opt/mirage2 --progress --delete --exclude-from .rsyncignore

echo ""
echo "Build starting!"
echo "--------------------------"
ssh -T mirage@inhji.de << EOSSH
cd /opt/mirage2
./scripts/build.sh
EOSSH

echo ""
echo "Build complete, restarting..."
echo "--------------------------"
ssh -T mirage@inhji.de sudo systemctl restart mirage2
