# spoon.family
Configuration for spoon.family server

/etc/hostname
```
spoon.family
```

Install DataDogAgent
```
DD_API_KEY=***REMOVED*** bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"
```

Install Base Utilities
```
apt-get clean
apt-get update
apt-get dist-upgrade
apt-get install htop
```

Install Docker
```
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common 
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce
```

Install Docker Compose
```
curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

Install Nginx
```
```
