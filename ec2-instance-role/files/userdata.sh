#!/bin/bash

sudo apt update -y
sudo apt install -y docker.io git ruby wget unzip 

# Docker and Dcoker compose 설치
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CE
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Java 설치
sudo apt install -y openjdk-17-jdk

cd /home/ubuntu

# JAVA_HOME 설정 (경로는 실제 설치 후 확인 필요)
echo 'export JAVA_HOME="/usr/lib/jvm/java-1.17.0-openjdk-amd64"' >> /home/ubuntu/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc

# aws cli 설치 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# sudo apt install -y zip unzip
# unzip awscliv2.zip
# sudo ./aws/install
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# codedeploy-agent 설치
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
sudo chmod u+x ./install
sudo ./install auto
sudo rm -rf ./install

sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent

sudo cat >/etc/init.d/codedeploy-start.sh <<EOL
#!/bin/bash
sudo service codedeploy-agent restart
EOL
sudo chmod +x /etc/init.d/codedeploy-start.sh

# ec2-user 도커 그룹 추가 및 권한 부여
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker

# # docker-compose 설치
# sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
