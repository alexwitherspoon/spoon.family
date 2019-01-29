# spoon.family
Configuration for spoon.family server

Read more about the project here: [https://alexwitherspoon.com/projects/private-family-chat-server/](https://alexwitherspoon.com/projects/private-family-chat-server/)

Below are steps, and any edited files from a base Debian Stable installation are included in the repo in the same file layout as on the filesystem. I used an c5.large large instance running in AWS, and two S3 buckets, one for mattermost file storage, and the second for Postgresql WAL logs+backups. 

/etc/hostname
```
spoon.family
```

## Install Base Utilities
```
apt-get clean
apt-get update
apt-get dist-upgrade
apt-get install htop
```

## Unattended Auto Updates
https://wiki.debian.org/UnattendedUpgrades
```
apt-get install unattended-upgrades apt-listchanges
```
Copy these configs : https://github.com/alexwitherspoon/spoon.family/tree/master/etc/apt/apt.conf.d

## Install DataDogAgent
```
DD_API_KEY=<YOUR-DATADOG-KEY> bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"
```

## Install Docker
```
apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common 
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce
```

## Configure DataDog
Give Access to Docker
```
usermod -a -G docker dd-agent
```
Edit /etc/datadog-agent/conf.d/docker_daemon.yaml
```
init_config:

instances:
    - url: "unix://var/run/docker.sock"
      new_tag_names: true
```

Edit /etc/datadog-agent/conf.d/nginx.yaml
```
init_config:

instances:
    # For every instance, you have an `nginx_status_url` and (optionally)
    # a list of tags.

    -   nginx_status_url: http://spoon.family/basic_status/
        tags:
            -   instance:spoon.family
```

Edit /etc/datadog-agent/conf.d/postgres.yaml
```
init_config:

instances:
   -   host: localhost
       port: 5432
       username: mmuser
       password: mmuser_password

       tags:
            - spoon.family
            - mattermost
```


## Install Docker Compose
```
curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## Install Nginx
Copy config from https://github.com/alexwitherspoon/spoon.family/tree/master/etc/nginx
```
apt-get install nginx
```

## Set up SSL certs
https://www.howtoforge.com/tutorial/install-letsencrypt-and-secure-nginx-in-debian-9/
```
apt-get install certbot
certbot certonly --webroot –w /var/www/html/ -d yourdomain.com –d www.yourdomain.com
```

## Start Main Mattermost Docker Service
```
cd /opt
git clone https://github.com/mattermost/mattermost-docker.git
cd /opt/mattermost-docker
docker-compose build
docker-compose up -d
```
Follow the Docker run commands for each remaining service in the https://github.com/alexwitherspoon/spoon.family/tree/master/docker folder individually.

## Set up aut-Mattermost Updates
Mattermost updates on the 16th of every month, so this script should be enabled for cron monthly on the 17th.
https://github.com/alexwitherspoon/spoon.family/blob/master/opt/UpdateMattermost.sh I placed this file in /opt

## Set Up Crontab jobs
```
## SSL Cert
@daily /usr/bin/certbot renew --noninteractive --renew-hook "/bin/systemctl reload nginx" >> /var/log/le-renew.log

#
## Base backup
@daily docker exec mattermost-db su - postgres sh -c "/usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-push /var/lib/postgresql/data"
# Keep the most recent 7 base backups and remove the old ones
@daily docker exec mattermost-db su - postgres sh -c "/usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e delete --confirm retain 7"

#
## Monthly Mattermost Update
0 4 17 * * /opt/UpdateMattermost.sh >> /var/log/syslog

#
## Clean Docker
0 0 1 * * docker system prune -af
0 0 2 * * docker images -q |xargs docker rmi
```


