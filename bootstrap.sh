export DEBIAN_FRONTEND=noninteractive

echo -e "\e[0;36m[Upgrading system]\e[0m"
# apt-get -qq update
# apt-get -yqq upgrade

if [ ! -f /usr/bin/curl ]; then
  echo -e "\e[0;36m[Installing curl]\e[0m"
  apt-get -yqq install curl
fi

if [ ! -f /usr/bin/git ]; then
  echo -e "\e[0;36m[Installing git]\e[0m"
  apt-get -yqq install git-core
fi

if [ ! -f /usr/bin/g++ ]; then
  echo -e "\e[0;36m[Installing build-essential]\e[0m"
  apt-get -yqq install build-essential
fi

if [ ! -f /usr/bin/mysql ]; then
  echo -e "\e[0;36m[Installing mysql]\e[0m"
  echo 'MySQL superuser password is "root"'

  echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections
  echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections
  apt-get -yqq install mysql-server
fi

if [ ! -f /etc/init.d/apache2 ]; then
  echo -e "\e[0;36m[Installing apache2, php5, phpmyadmin]\e[0m"

  echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
  apt-get -yqq install apache2 php5 php5-cli phpmyadmin
fi

if grep --quiet Singapore /etc/timezone; then
  echo -e "Timezone is ok"
else 
  echo -e "\e[0;36m[Setting time zone]\e[0m"
  echo "Asia/Singapore" | sudo tee /etc/timezone
  dpkg-reconfigure --frontend noninteractive tzdata
fi

if [ ! -d /home/vagrant/.nvm ]; then
  echo -e "\e[0;36m[Installing nvm]\e[0m"
  if [ ! -f /usr/bin/node ]; then
    echo -e "Removing npm from apt-get"
    apt-get remove nodejs npm && apt-get autoremove
    rm -f /etc/apt/sources.list.d/nodesource.list
  fi
  export HOME=/home/vagrant
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash
  echo "source ~/.nvm/nvm.sh" >> /home/vagrant/.bashrc
  source /home/vagrant/.nvm/nvm.sh
  nvm install 0.10 > /dev/null 2> /dev/null
  nvm install 0.12 > /dev/null 2> /dev/null
  chown -R vagrant:vagrant /home/vagrant/.nvm
  echo "Using node `nvm current`"
  export HOME=/home/root
fi


function npm_globals {
  source /home/vagrant/.nvm/nvm.sh
  nvm use $1

  if ! type grunt; then
    echo -e "\e[0;36m[Installing grunt for $1]\e[0m"
    npm -g --silent install grunt-cli
    chown -R vagrant:vagrant /home/vagrant/.nvm
  fi

  if ! type sails; then
    echo -e "\e[0;36m[Installing sails for $1]\e[0m"
    npm -g --silent install sails
    chown -R vagrant:vagrant /home/vagrant/.nvm
  fi

  if ! type bower; then
    echo -e "\e[0;36m[Installing bower for $1]\e[0m"
    npm -g --silent install bower
    chown -R vagrant:vagrant /home/vagrant/.nvm
  fi
}

npm_globals 0.10
npm_globals 0.12
