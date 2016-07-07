#!/usr/bin/env bash

# ----------------- Install Development Tools Group ----------------- #
echo "-- Installing Yum Group Development Tools --"

yum -y -q groupinstall "Development Tools"

yum -y -q install mysql-utilities mysql-devel

echo "-- Yum Group Development Tools Installed --"


# ----------------- Get Tomcat 7 ----------------- #
echo "-- Installing Tomcat 7 --"

#get tomcat 7 from apache
wget http://apache.parentingamerica.com/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz -P /opt 1> NUL 2> NUL

#untar
tar -zxf /opt/apache-tomcat-7.0.70.tar.gz -C /opt

#move the folder to just tomcat
mv /opt/apache-tomcat-7.0.70.tar.gz /opt/tomcat

#remove the archive
rm -f /opt/apache-tomcat-7.0.70.tar.gz

#remove default webapps
rm -rf /opt/tomcat/webapps/*

echo "-- Tomcat Installed to /opt/tomcat --"



# ----------------- Install Java 1.8 (8) ----------------- #
echo "-- Installing Java 1.8 --"

#move to temp
cd /tmp	

#download oracle jre
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jre-8u60-linux-x64.rpm" 1> NUL 2> NUL
echo "-- JRE Downloaded --"

#download oracle jdk
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm" 1> NUL 2> NUL
echo "-- JDK Downloaded --"

#install jre
yum -y -q localinstall jre-8u60-linux-x64.rpm

#install jdk
yum -y -q localinstall jdk-8u60-linux-x64.rpm

echo "-- Java 1.8 Installed --"


# ----------------- Install Maven ----------------- #
echo "-- Installing Maven --"

#download mvn 3.0
wget http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz 1> NUL 2> NUL

#untar to /usr/local
tar -xzf apache-maven-3.0.5-bin.tar.gz -C /usr/local

#move to usr/local
cd /usr/local

#system link the folder to maven
ln -s apache-maven-3.0.5 maven

#make the file
touch /etc/profile.d/maven.sh

#run it now so we don't have to login/logout
/etc/profile.d/maven.sh

#add mvn to the PATH in /etc/profile
echo "PATH=$PATH:/usr/local/maven/bin/" >> /etc/profile

echo "-- Maven Installed --"


# ----------------- Install MySql ----------------- #
echo "-- Installing Mysql --"

# Sudo yum -y update
yum -y -q install mysql-server

# Restart mysql
service mysqld restart

# Set root password
/usr/bin/mysqladmin -u root password 'password'

# Allow remote access
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"

# Drop the anonymous users
mysql -u root -ppassword -e "DROP USER ''@'localhost';"
mysql -u root -ppassword -e "DROP USER ''@'$(hostname)';"

# Drop the demo database
mysql -u root -ppassword -e "DROP DATABASE test;"

# Flush privledges
mysql -u root -ppassword -e "FLUSH PRIVILEGES;"

# Restart the mysqld service
service mysqld restart

# Set mysqld to start on system start
chkconfig mysqld on

#Install the mysql oracle connector
cd /opt
wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.37.tar.gz 1> NUL 2> NUL
tar -xzf mysql-connector-java-5.1.37.tar.gz -C /opt
mv /opt/mysql-connector-java-5.1.37/mysql-connector-java-5.1.37-bin.jar /opt/tomcat/common/lib
rm -rf /opt/mysql-connector-java-5.1.37

echo "-- Mysql Installed --"


# ----------------- Clone Sakai into /opt/sakai-src ----------------- #
echo "-- Cloning Sakai source --"

# make a new dir for sakai-src
mkdir /opt/sakai-src

# move there
cd /opt/sakai-src

#clone the most recent version of sakai
git clone https://github.com/sakaiproject/sakai.git

echo "-- Sakai source cloned into /opt/sakai-src --"


# ----------------- Set Environmental Variables ----------------- #
echo "-- Setting Environmental Variables --"

#Set JAVA_HOME
echo "export JAVA_HOME=/usr/java/jdk1.8.0_60" >> /etc/profile

#Set CATALINA_HOME
echo "export CATALINA_HOME=/opt/tomcat" >> /etc/profile

#Reload profile
source /etc/profile

#Set JAVA_OPTS in tomcat env file
touch /opt/tomcat/bin/setenv.sh
echo "export JAVA_OPTS='-server -Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -XX:NewSize=192m -XX:MaxNewSize=384m -Djava.awt.headless=true -Dhttp.agent=Sakai -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Dsun.lang.ClassLoader.allowArraySyntax=true'" >> /opt/tomcat/bin/setenv.sh

echo "-- Environmental Variables Set --"
