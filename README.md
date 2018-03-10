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
