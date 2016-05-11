# hashId-Zimbra-8.6.0-Docker-FullyAutomated

# Install on Baremetal or Virtual Machine
If you prefer you can install Zimbra Fully Automated in a Baremetal or Virtual Machine, see instructions below.

```bash
git clone https://github.com/richardsonlima/hashId-Zimbra-8.6.0-Docker-FullyAutomated.git
```

```bash
cd hashId-Zimbra-8.6.0-Docker-FullyAutomated/docker/opt && chmod +x *.sh
```

```bash
./Zimbra-8.6.0.UbuntuSrv_AutoInstall.sh
```

##Advantages of use the Script
 * Time saving
 * Fully automated
 * Easy to use
 * Good for a quick Zimbra Preview

 ## ToDo
 - [ ] ...

# Docker
## Install Docker

###Using git
Download from github, you will need git installed on your OS

```bash
git clone https://github.com/richardsonlima/hashId-Zimbra-8.6.0-Docker-FullyAutomated.git
```

##Build the image using the Dockerfile
The `Makefile` in the docker/ directory provides you with a convenient way to build your docker image. You will need make on your OS. Just run

```bash
cd hashId-Zimbra-8.6.0-Docker-FullyAutomated/docker
sudo make
```

The default image name is zimbra_docker. You can specify a different image name by setting the `Image` variable:

```bash
cd hashId-Zimbra-8.6.0-Docker-FullyAutomated/docker
sudo IMAGE=YourImageName make
```

##Deploy the Docker container

Example:
```bash
docker run -p 25:25 -p 80:80 -p 465:465 -p 587:587 -p 110:110 -p 143:143 -p 993:993 -p 995:995 -p 443:443 -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 -h zimbra-docker.zimbra.io --dns 127.0.0.1 --dns 8.8.8.8 -i -t -e PASSWORD=Zimbra2016 hashId-Zimbra-8.6.0-Docker-FullyAutomated
```

##Known issues##
After the Zimbra automated installation, the docker container will exit and keep in stopped state, you just need to run the next commands to start your Zimbra Container:

```bash
docker ps -a
docker start YOURCONTAINERID
docker exec -it YOURCONTAINERID bash
su - zimbra
zmcontrol restart
```
