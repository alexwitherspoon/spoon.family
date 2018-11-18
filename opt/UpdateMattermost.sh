#!/bin/bash
# https://github.com/alexwitherspoon/spoon.family
# Update Mattermost Automatically

echo "`date +"%T-%m-%d-%Y"`: Starting Mattermost Upgrade"
cd /opt/mattermost-docker/
echo "`date +"%T-%m-%d-%Y"`: Shutting down existing Mattermost"
docker-compose down
echo "`date +"%T-%m-%d-%Y"`: Updating Git Repo"
/usr/bin/git pull
/usr/bin/git status
echo "`date +"%T-%m-%d-%Y"`: Building Mattermost Containers"
docker-compose build
echo "`date +"%T-%m-%d-%Y"`: Starting new Mattermost Containers"
docker-compose up -d
