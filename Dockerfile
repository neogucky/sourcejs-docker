FROM mkenney/npm:node-6.9-debian

MAINTAINER Tim Rasim "rasim@imis.uni-luebeck.de"

# Prepare for mongo
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Update
RUN apt-get update

# Install software 
RUN apt-get install -y git mongodb-org

# WORKARROUND copy private keys into the container (this should be done by shared volumes) 
RUN mkdir /root/.ssh/
ADD dockerKeys/ /root/.ssh/
RUN chmod 400 /root/.ssh/ -R
WORKDIR /root/.ssh/
RUN ssh-keyscan -t rsa dev.imis.uni-luebeck.de 2>&1 >> /root/.ssh/known_hosts
RUN ls -l # This displys the id_rsa key folder. If empty the folder was not added correctly

# Clone our repository into the docker container
RUN git clone ssh://git@dev.imis.uni-luebeck.de/netzdatenstrom/netz-daten-strom.git /home/sourcejs/

WORKDIR /home/sourcejs/
RUN cd sourcejs npm install sourcejs --save npm start

# Update node modules defined in package.json 
WORKDIR /home/sourcejs/netz-daten-strom/
RUN npm update

# Install webhook
WORKDIR /home/sourcejs/deployment/
RUN sh installGo.sh
ENV GOPATH=$HOME/work
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get github.com/adnanh/webhook

# Prepare webhook for continious integration
#EXPOSE 9000
#WORKDIR /home/sourcejs/deployment/
#ENTRYPOINT ["webhook", "-hooks hooks.json -verbose"]

# prepare sourcejs start
EXPOSE 8080
#WORKDIR /home/sourcejs/netz-daten-strom/node_modules/sourcejs/
#ENTRYPOINT sh /home/sourcejs/deployment/startSourcejs.sh
#CMD [ "npm", "start"] #echo "Starting SourceJS.."
