Pull:
sudo docker pull neogucky/sourcejs

This image now supports branch selection on start. Usage:

%PORT% = The port of the host machine. If unsure use: 8080
%BRANCH" = The sourcejs branch you want to pull. If unsure use: remotes/origin/master

docker run -dit -p %PORT%:8080 neogucky/sourcejs:latest /bin/bash startSourcejs.sh %BRANCH%

Examples:
//Testbranch "dev_test" on "remotes/origin"
docker run -dit -p 8080:8080 neogucky/sourcejs:latest /bin/bash startSourcejs.sh remotes/origin/dev_test

//Master branch (default)
docker run -dit -p 8080:8080 neogucky/sourcejs:latest /bin/bash startSourcejs.sh remotes/origin/master

Auto-restart (recommandation when running on a server):
docker run -dit --restart always -p 8080:8080 neogucky/sourcejs:latest /bin/bash startSourcejs.sh remotes/origin/master

Debug
When debugging you can either remove the "-d" flag to start the container attached or manually attach it with
docker attach CONTAINERID

Example:
//Start the container with attached shell without automatically start SourceJS
docker run -it -p 8080:8080 neogucky/sourcejs:latest /bin/bash

After starting the docker container wait one or two minutes until it has started completely. If you ran the container locally on port 8080 access sourceJS with this url in your browser:

localhost:8080 


Build image:
sudo docker build --no-cache -t neogucky/sourcejs . &&  sudo docker push neogucky/sourcejs

Start docker-compose with mongo:
//Go to folder with docker-compose.yml  (i.e. sourcejs-docker/port80)
// -p ###### should be a unique name: sourceJStest for port82 or sourceJSproductive for port80
sudo docker-compose -p ###### up -d

possible problems: port already in use. Look up conflicting port with sudo docker ps and stop the container.

## Maintenance 

To stop the composed docker file do the following:

1. get IDs of sourcejs and mongo
  docker ps 
  
2. stop and remove
  docker stop ID1 ID2 && docker rm ID1 ID2
  
