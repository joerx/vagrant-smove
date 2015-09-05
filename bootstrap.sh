export DEBIAN_FRONTEND=noninteractive

# Fix locale
if ! cat /etc/default/locale | grep LC_ALL > /dev/null; then
  echo -e "\e[0;36m[Setting locale]\e[0m"
  printf 'LANG="en_US.UTF-8"\nLC_ALL="en_US.UTF-8"' > /etc/default/locale
  . /etc/default/locale
  dpkg-reconfigure locales
fi

# Upgrade everything
echo -e "\e[0;36m[Upgrading system]\e[0m"
# apt-get -qq update
# apt-get -yqq upgrade

# Curl
if [ ! -f /usr/bin/curl ]; then
  echo -e "\e[0;36m[Installing curl]\e[0m"
  apt-get -yqq install curl
fi

# Git
if [ ! -f /usr/bin/git ]; then
  echo -e "\e[0;36m[Installing git]\e[0m"
  apt-get -yqq install git-core
fi

# Build essentials (needed by nodejs)
if [ ! -f /usr/bin/g++ ]; then
  echo -e "\e[0;36m[Installing build-essential]\e[0m"
  apt-get -yqq install build-essential
fi

# MySQL server, using 'root' as root pw. It's just a dev box after all
if [ ! -f /usr/bin/mysql ]; then
  echo -e "\e[0;36m[Installing mysql]\e[0m"
  echo 'MySQL superuser password is "root"'

  echo 'mysql-server mysql-server/root_password password root' | debconf-set-selections
  echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections
  apt-get -yqq install mysql-server
fi

# Apache, php5, phpmyadmin
if [ ! -f /etc/init.d/apache2 ]; then
  echo -e "\e[0;36m[Installing apache2, php5, phpmyadmin]\e[0m"

  echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
  echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
  apt-get -yqq install apache2 php5 php5-cli phpmyadmin php5-mcrypt
  a2enmod rewrite
  php5enmod mcrypt
  service apache2 restart
fi

# TZ must be Singapore
if grep --quiet Singapore /etc/timezone; then
  echo -e "\e[0;36m[Timezone is OK]\e[0m"
else 
  echo -e "\e[0;36m[Setting time zone]\e[0m"
  echo "Asia/Singapore" | sudo tee /etc/timezone
  dpkg-reconfigure --frontend noninteractive tzdata
fi

# Node.js - install globally or deployment via shipit.js won't work
if [ ! -f /usr/bin/node ]; then
  echo -e "\e[0;36m[Installing nodejs 0.12]\e[0m"
  curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
  echo "deb https://deb.nodesource.com/node_0.12 vivid main" > /etc/apt/sources.list.d/nodesource.list
  apt-get -qq update
  apt-get -yqq install nodejs
  npm -g --silent install grunt-cli bower
fi
