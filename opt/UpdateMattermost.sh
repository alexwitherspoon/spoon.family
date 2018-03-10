#!/bin/bash
# https://github.com/alexwitherspoon/spoon.family
# Update Mattermost Automatically

cd /opt/mattermost-docker
docker-compose down
git pull
docker-compose build
docker-compose up -d
