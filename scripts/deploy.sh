#!/usr/bin/env bash

MIRAGE_HOST=inhji.de
MIRAGE_DIR=/home/inhji/www/mirage/app

echo ""
echo "Pushing changes..."
echo "--------------------------"
rsync -avz . $MIRAGE_HOST:$MIRAGE_DIR --progress --delete --exclude-from .rsyncignore

echo ""
echo "Build starting!"
echo "--------------------------"
ssh -T $MIRAGE_HOST << EOSSH
cd $MIRAGE_DIR
./scripts/build.sh
EOSSH

echo ""
echo "Build complete, restarting..."
echo "--------------------------"
ssh -T $MIRAGE_HOST sudo systemctl restart mirage
