FROM mkenney/npm:node-6.9-debian

MAINTAINER Tim Rasim "rasim@imis.uni-luebeck.de"

# Prepare for mongo
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Update
RUN apt-get update

# Install software 
RUN apt-get install -y git mongodb-org webhook

# WORKARROUND copy private keys into the container (this should be done by shared volumes) 
RUN mkdir /root/.ssh/
ADD dockerKeys/ /root/.ssh/
RUN chmod 400 /root/.ssh/ -R
WORKDIR /root/.ssh/
RUN ssh-keyscan -t rsa dev.imis.uni-luebeck.de 2>&1 >> /root/.ssh/known_hosts
RUN ls -l # This displys the id_rsa key folder. If empty the folder was not added correctly

# Clone our repository into the docker container
RUN git clone ssh://git@dev.imis.uni-luebeck.de/netzdatenstrom/netz-daten-strom.git /home/my-sourcejs/

WORKDIR /home/my-sourcejs/
#RUN git clone https://github.com/sourcejs/init.git -b npm my-sourcejs && cd my-sourcejs npm install sourcejs --save npm start
RUN cd sourcejs npm install sourcejs --save npm start

# Update node modules defined in package.json 
WORKDIR /home/my-sourcejs/netz-daten-strom/
RUN npm update

# prepare sourcejs start
EXPOSE 8080
WORKDIR /home/my-sourcejs/netz-daten-strom/node_modules/sourcejs/

CMD [ "npm", "start"] #echo "Starting SourceJS.."
