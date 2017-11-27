FROM mkenney/npm:node-7-debian

MAINTAINER Tim Rasim "rasim@imis.uni-luebeck.de"

# Update
RUN apt-get update

# Install software 
RUN apt-get install -y git

WORKDIR /home/
RUN git clone https://github.com/sourcejs/init.git -b npm my-sourcejs && cd my-sourcejs npm install sourcejs --save npm start

#WORKARROUND copy private keys into the container (this should be done by shared volumes) 
ADD dockerKeys/* ~/.ssh/

# Clone the repository into the docker container
WORKDIR /home/my-source/
RUN git clone ssh://git@dev.imis.uni-luebeck.de/netzdatenstrom/netz-daten-strom.git

# Update node modules defined in package.json 
WORKDIR /home/my-source/netz-daten-strom/
RUN npm update

# Start sourcejs
EXPOSE 80
WORKDIR /home/my-sourcejs/node_modules/sourcejs/
RUN echo "Starting SourceJS.."
CMD [ "npm", "start", "-- -p 80"]
