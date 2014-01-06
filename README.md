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
rvm install 1.9.3 
rvm use 1.9.3@rails3 --create --default
```

setup gems
``` shell
wget http://rubyforge.org/frs/download.php/76729/rubygems-1.8.25.tgz 
ruby setup.rb
``` 
setup gems source
``` shell
gem sources --remove https://rubygems.org/
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
sudo service mysqld start
sudo chkconfig mysqld on 
``` 

setup JDK
``` shell 
sudo apt-get install openjdk-6-jdk

# add below line to .bashrc
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
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

``` 
