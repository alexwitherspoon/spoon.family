# spoon.family
Configuration for spoon.family server

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

## Install DataDogAgent
```
DD_API_KEY=***REMOVED*** bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"
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
```
```
