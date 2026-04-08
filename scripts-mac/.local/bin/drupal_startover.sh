#!/bin/bash

set -e

lando destroy -y
cd ..
sudo rm -rf yalesites-project
git clone git@github.com:yalesites-org/yalesites-project.git
cd yalesites-project
npm run setup
