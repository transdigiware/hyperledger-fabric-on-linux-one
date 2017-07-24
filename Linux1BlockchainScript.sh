#1/bin/bash/

#Give the linux1 userid permission to run docker commands
echo -e “*** modify linux1 groups to allow userid to run docker commands ***”
sudo usermod -g docker linux1

#Install NodeJS
echo -e “*** install_nodejs ***”
cd /tmp
wget -q https://nodejs.org/dist/v6.9.5/node-v6.9.5-linux-s390x.tar.gz
cd /usr/local && sudo tar --strip-components=1 -xzf /tmp/node-v6.9.5-linux-s390x.tar.gz
echo -e “*** Done withe NodeJS ***\n”


#Setup and install docker-compose
echo -e “*** Installing docker-compose. ***\n”
sudo zypper install -y python-pyOpenSSL python-setuptools
sudo easy_install pip
sudo pip install docker-compose==1.13.0
echo -e “*** Done with docker-compose. ***\n”


#Pull s390x-1.0.0-rc1 fabric containers from DockerHub
echo -e “*** Pulling s390x-1.0.0-rc1 images from DockerHub. ***\n”
sudo docker pull hyperledger/fabric-peer:s390x-1.0.0-rc1
sudo docker pull hyperledger/fabric-ca:s390x-1.0.0-rc1
sudo docker pull hyperledger/fabric-orderer:s390x-1.0.0-rc1
sudo docker pull hyperledger/fabric-couchdb:s390x-1.0.0-rc1
echo -e “*** All fabric containers have been pulled. ***\n”

#Install Hyperledger Composer Components
echo -e “*** Installing Hyperledger Composer command line tools. ***\n”
mkdir /data/linux1/ 
npm config set prefix '/data/npm'
npm config set cache /data/linux1/.npm
export PATH=/data/npm/bin:$PATH
cd /data/linux1/
npm install -g composer-cli@0.9.2

echo -e “*** Installing Hyperledger Composer rest server. ***\n”
npm install -g composer-rest-server@0.9.2

echo -e “*** Installing Hyperledger Composer playground. ***\n”
npm install -g composer-playground@0.9.2

#Install NodeRed
echo -e "*** Installing NodeRed. ***\n"
npm install -g node-red
