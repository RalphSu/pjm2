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
RAILS_ENV=production rake db:migrate 
rake generate_session_store
``` 
