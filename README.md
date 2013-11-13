PJM

Add by Ralph

set up rvm&ruby
\curl -L https://get.rvm.io | bash rvm get head && rvm reload source /home/jiangh/.rvm/scripts/rvm rvm install 1.9.3 rvm use 1.9.3@rails3 --create --default

setup gems
wget http://rubyforge.org/frs/download.php/76729/rubygems-1.8.25.tgz ruby setup.rb

install rails
gem install rails -v 3.2.13

setup pjm
sudo apt-get install libmagickwand-dev sudo apt-get install libmysql-ruby libmysqlclient-dev

mysql> CREATE DATABASE redmine CHARACTER SET utf8; mysql> CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'redmine'; mysql> GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';

bundle install --without development test RAILS_ENV=production rake db:migrate rake generate_secret_token
