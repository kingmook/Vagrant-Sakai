# Vagrant-Sakai
A vagrant file for setting up some base Sakai CLE requirement in a VM

Requirements:
Virtualbox
Vagrant

Installs:
- bento Centos 6.7
- yum "Development Tools"
- Tomcat 7
- Java 1.8 JRE & JDK
- Maven 3.0
- Mysql 
- Mysql Java connector 5.1
- Apereo Sakai Trunk source code

Configures:
- CATALINA_HOME
- JAVA_HOME
- JAVA_OPTS

Requires:
- Vagrant
- Virtual Box


Use:
- git clone https://github.com/kingmook/Vagrant-Sakai
- vagrant up
- wait a long time for it to download and configure all the requirements (~10-15 minutes)


Inspiration and bits of code from https://github.com/steveswinsburg/mysql-vagrant and https://github.com/tiangolo/ansible-babun-bootstrap



