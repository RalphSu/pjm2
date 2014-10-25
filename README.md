PJM

set up sublime
``` shell
wget http://c758482.r82.cf2.rackcdn.com/Sublime\ Text\ 2.0.2\ x64.tar.bz2
tar vxjf Sublime\ Text\ 2.0.2.tar.bz2
sudo mv Sublime\ Text\ 2 /opt/
sudo ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/subl
```



set up rvm&ruby
``` shell
\curl -L https://get.rvm.io | bash stable
source /home/jiangh/.rvm/scripts/rvm
#for mac, may need a new shell window
rvm install 1.9.3 
rvm use 1.9.3@rails3 --create --default
```

```
On MAC
LM-SHC-00950363:repository liasu$ rvm use 2.1.2

RVM is not a function, selecting rubies with 'rvm use ...' will not work.

You need to change your terminal emulator preferences to allow login shell.
Sometimes it is required to use `/bin/bash --login` as the command.
Please visit https://rvm.io/integration/gnome-terminal/ for an example.

```

setup gems
``` shell
wget http://rubyforge.org/frs/download.php/76729/rubygems-1.8.25.tgz 
#for mac curl -L http://rubyforge.org/frs/download.php/76729/rubygems-1.8.25.tgz -o ./rubygems-1.8.25.tgz 
tar -xvf rubygems-1.8.25.tgz
ruby rubygems-1.8.25/setup.rb
``` 
setup gems source
``` shell
gem sources --remove https://rubygems.org/
gem sources --remove http://rubygems.org/
gem sources -a http://ruby.taobao.org/

``` 


install rails
``` shell
gem install rails -v 2.3.18
```
// source.index is deprecated in ROR
``` shell 
gem update --system 1.8.25
```

setup mysql
``` shell 
sudo yum install mysql-server, mysql
#sudo apt-get inlstall mysql-server
sudo service mysqld start
#for ubuntu
#sudo service mysql restart

sudo chkconfig mysqld on
#for ubuntu
sudo sysv-rc-conf mysql on

``` 

setup JDK
``` shell 
# install sun java-7 JDK. setup JAVA_HOME

# add below line to .bashrc
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/client
``` 

setup iptables : NAT to 80 from 8080
``` shell 
# redirect request on interface eth0 from 80 to 8080
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
sudo iptables-save
``` 


setup pjm
``` shell
sudo apt-get install libmagickwand-dev 
sudo apt-get install libmysql-ruby libmysqlclient-dev
gem install execjs # if report no javascript runtime. https://github.com/sstephenson/execjs
# sudo yum install ImageMagick-devel
# sudo yum install mysql-devel

# mysql -u root -p 
mysql> CREATE DATABASE chiliproject CHARACTER SET utf8;
mysql> CREATE USER 'chiliproject'@'localhost' IDENTIFIED BY 'chili'; 
mysql> GRANT ALL PRIVILEGES ON chiliproject.* TO 'chiliproject'@'localhost';

bundle install --without development test 
rake generate_session_store

RAILS_ENV=production rake db:migrate 
RAILS_ENV=production bundle exec rake redmine:load_default_data
# choose en

#Re-Run schema-migration to rename role
# enter mysql,  
delete from schema_migrations where version="20131203062739";
exit;

> RAILS_ENV=production rake db:migrate

#update mysql encoding
#edit /etc/mysql/my.cnf 
#add below to [client] section 
 default-character-set=utf8
#add below to [mysqld] section
 character-set-server=utf8
#add below to [mysql] section
 default-character-set=utf8
#restart mysql service and check encoding show variables like 'character%'; 


#data migration
#migrate mysql data
#From
tar -cvf chiliproject.tar ./chiliproject/
tar -cvf mysql.tar ./mysql
scp chiliproject.tar keyi@180.153.154.43:/home/keyi/
scp mysql.tar keyi@180.153.154.43:/home/keyi/
 scp ibdata1 keyi@180.153.154.43:/home/keyi/
 scp ib_logfile0 keyi@180.153.154.43:/home/keyi/
 scp ib_logfile1 keyi@180.153.154.43:/home/keyi/
#To
/var/lib/mysql# chown mysql:mysql ib*

#migrate images and reports
#From
tar -cvf reports.tar ./report
tar -cvf upload.tar ./public/upload
scp them
#To
tar -xvf
 
```


