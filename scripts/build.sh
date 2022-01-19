#!/usr/bin/env bash

echo ""
echo "Installing Hex/Rebar"
echo "--------------------------"
MIX_ENV=prod mix local.hex --if-missing --force
MIX_ENV=prod mix local.rebar --if-missing --force

echo ""
echo "Getting/compiling Hex dependencies"
echo "--------------------------"
MIX_ENV=prod mix deps.get --only prod
MIX_ENV=prod mix deps.compile

echo ""
echo "Getting/compiling Assets"
echo "--------------------------"
npm install --prefix ./assets
MIX_ENV=prod mix assets.deploy

echo ""
echo "Generating documentation"
echo "--------------------------"
MIX_ENV=prod mix docs


echo ""
echo "Generating release"
echo "--------------------------"
MIX_ENV=prod mix release --overwrite
