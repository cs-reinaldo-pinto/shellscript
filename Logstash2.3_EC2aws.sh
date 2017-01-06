#!/bin/bash

function UpdateInstallServices(){
	sudo yum update -y
}

function InstallLogstash(){
	sudo bash -c 'printf "[logstash-2.3]\nname=Logstash repository for 2.3.x packages\nbaseurl=https://packages.elastic.co/logstash/2.3/centos\ngpgcheck=1\ngpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch\nenabled=1" > /etc/yum.repos.d/logstash.repo'
	sudo yum install logstash -y
}

function InstallJava(){
	sudo java -version
	sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz"
	sudo tar -xvzf jdk-8u111-linux-x64.tar.gz
	sudo cp -pR jdk1.8.0_111/ /opt/
	package_atual=`sudo rpm -qa |grep -e 'java-1.[0-9].[0-9]-openjdk-1.[0-9]'`
	sudo rpm -e $package_atual --nodeps #java-1.7.0-openjdk-1.7.0.121-2.6.8.1.69.amzn1.x86_64
	cd /opt/jdk1.8.0_111/
	sudo alternatives --install /usr/bin/java java /opt/jdk1.8.0_111/bin/java 2
	sudo alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_111/bin/jar 2
	sudo alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_111/bin/javac 2
	sudo alternatives --set jar /opt/jdk1.8.0_111/bin/jar
	sudo alternatives --set javac /opt/jdk1.8.0_111/bin/javac
	sudo java -version # java version "1.8.0_111"
	export JAVA_HOME=/opt/jdk1.8.0_111/
	export JAVA_HOME=/opt/jdk1.8.0_111/jre
	export PATH=$PATH:/opt/jdk1.8.0_111/bin/:/opt/jdk1.8.0_111/jre/bin
	echo $PATH  #/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin:/opt/jdk1.8.0_111/bin/:/opt/jdk1.8.0_111/jre/bin
	cd ~
}

function DownloadPackages(){
	cd /opt
	sudo git clone https://github.com/elastic/elasticsearch-cloud-aws.git
	sudo wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.zip
	sudo git clone https://github.com/awslabs/logstash-output-amazon_es.git
	sudo git clone https://github.com/elastic/elasticsearch-cloud-aws.git
	sudo git clone https://github.com/awslabs/logstash-output-amazon_es.git
	sudo unzip elasticsearch-1.5.0.zip
	cd ~
}

function InstallElasticSearch(){
	cd /opt/elasticsearch-1.5.0
	sudo ./bin/plugin install elasticsearch/elasticsearch-cloud-aws/2.5.1
}

function InstallLogstashPlugin(){
	cd /opt/logstash
	sudo ./bin/plugin install logstash-filter-translate
	sudo ./bin/plugin install logstash-output-amazon_es
	sudo ./bin/plugin install logstash-filter-translate
	gem install bundler
	cd /opt/logstash-output-amazon_es/
	sudo gem build logstash-output-amazon_es.gemspec
	cd /opt/logstash
	sudo ./bin/plugin install  vendor/bundle/jruby/1.9/cache/logstash-output-amazon_es-1.0-java.gem
	sudo rpm -qa |grep logstash #logstash-2.3.4-1.noarch rpm -qa |grep elasticsearch #elasticsearch-5.0.1-1.noarch
}

function ConfigLogstash(){
	cd ~ && cd aws-scripts/logstash/
	cp logstash.conf /etc/logstash/conf.d/
	cd ~
}

function StartLogstash(){
	sudo service logstash start
	sudo chkconfig logstash on
}

#Steps
UpdateInstallServices
InstallLogstash
InstallJava
DownloadPackages
InstallElasticSearch
InstallLogstashPlugin
ConfigLogstash  #Change hosts
StartLogstash
