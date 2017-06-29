#!/bin/bash
set -e
echo "#########################################"
echo "###############Prepare Env###############"
echo "#########################################"
apt-get update
apt-get install -y unzip python2.7 g++ expect openjdk-8-jdk openjdk-8-jre
cp /usr/bin/python2.7 /usr/bin/python
echo "#########################################"
echo "###############Install GO ###############"
echo "#########################################"
wget https://storage.googleapis.com/golang/go1.8.1.linux-s390x.tar.gz
chmod ugo+r go1.8.1.linux-s390x.tar.gz
sudo tar -C /usr/local -xzf go1.8.1.linux-s390x.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "PATH=\$PATH:/usr/local/go/bin" >> /root/.bashrc
rm go1.8.1.linux-s390x.tar.gz
echo "#########################################"
echo "#############Install NodejS##############"
echo "#########################################"
wget http://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/nodejs/6.10.2.0/linux/s390x/ibm-6.10.2.0-node-v6.10.2-linux-s390x.bin
chmod 555 ./ibm-6.10.2.0-node-v6.10.2-linux-s390x.bin
/usr/bin/expect <<-EOF
spawn ./ibm-6.10.2.0-node-v6.10.2-linux-s390x.bin
expect "CHOOSE LOCALE BY NUMBER:"
send "5\r"
set timeout 300
expect "PRESS <ENTER> TO CONTINUE:"
send "\r"
set timeout 300
expect "or \"99\" to go back to the previous screen.:"
send "1\r"
expect "      :"
send "/opt/ibm/node\r"
expect "IS THIS CORRECT? (Y/N):"
send "y\r"
expect "      :"
send "\r"
expect "PRESS <ENTER> TO CONTINUE:"
send "\r"
expect "PRESS <ENTER> TO INSTALL:"
send "\r"
set timeout 300
expect "PRESS <ENTER> TO EXIT THE INSTALLER:"
send "\r"
EOF
rm ibm-6.10.2.0-node-v6.10.2-linux-s390x.bin
export PATH=$PATH:/opt/ibm/node/bin
echo "PATH=\$PATH:/opt/ibm/node/bin" >> /root/.bashrc
. /root/.bashrc
echo "#########################################"
echo "#############Install Docker##############"
echo "#########################################"
apt-get install -y docker.io
curl  "https://bootstrap.pypa.io/get-pip.py"  -o  "get-pip.py"
python  get-pip.py
pip install docker-compose
rm get-pip.py
nohup docker daemon -g /var/lib/docker -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &
sleep 2
echo "#########################################"
echo "#########Pull hyperledger image##########"
echo "#########################################"
docker pull hyperledger/fabric-ca:s390x-1.0.0-beta
docker tag hyperledger/fabric-ca:s390x-1.0.0-beta hyperledger/fabric-ca:latest

docker pull hyperledger/fabric-couchdb:s390x-1.0.0-beta
docker tag hyperledger/fabric-couchdb:s390x-1.0.0-beta hyperledger/fabric-couchdb:latest

docker pull hyperledger/fabric-orderer:s390x-1.0.0-beta
docker tag hyperledger/fabric-orderer:s390x-1.0.0-beta hyperledger/fabric-orderer:latest

docker pull  hyperledger/fabric-peer:s390x-1.0.0-beta
docker tag  hyperledger/fabric-peer:s390x-1.0.0-beta hyperledger/fabric-peer:latest

docker pull hyperledger/fabric-javaenv:s390x-1.0.0-beta
docker tag hyperledger/fabric-javaenv:s390x-1.0.0-beta hyperledger/fabric-javaenv:latest

docker pull hyperledger/fabric-ccenv:s390x-1.0.0-beta
docker tag hyperledger/fabric-ccenv:s390x-1.0.0-beta hyperledger/fabric-ccenv:latest

docker pull hyperledger/fabric-baseimage:s390x-0.3.0

docker pull hyperledger/fabric-baseos:s390x-0.3.0
echo "#########################################"
echo "#############Get fabric code#############"
echo "#########################################"
cd /usr/local
wget https://github.com/hyperledger/fabric-sdk-node/archive/v1.0.0-beta.zip
unzip v1.0.0-beta.zip
rm v1.0.0-beta.zip
echo "#########################################"
echo "###########Init BlockChian Env###########"
echo "#########################################"
cd /usr/local/fabric-sdk-node-1.0.0-beta
npm install --unsafe-perm
npm install -g gulp
gulp ca
docker-compose -f test/fixtures/docker-compose.yaml up -d 
echo "#########################################"
echo "##############Create Channel#############"
node test/integration/e2e/create-channel.js
echo "###############Join Channel##############"
node test/integration/e2e/join-channel.js
echo "############Install Chaincode############"
node test/integration/e2e/install-chaincode.js
echo "###############Instantiate###############"
node test/integration/e2e/instantiate-chaincode.js
echo "#################Invoke##################"
node test/integration/e2e/invoke-transaction.js
echo "##################Query##################"
node test/integration/e2e/query.js
echo "#########################################"