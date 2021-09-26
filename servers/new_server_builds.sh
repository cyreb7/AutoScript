# *************************** Python ************************

sudo apt update;
yes | sudo apt install software-properties-common;
yes "" | sudo add-apt-repository ppa:deadsnakes/ppa;
sudo apt update;
yes | sudo apt install python3.8;
yes | sudo apt-get install libpq-dev python-dev;


# *************************** VirtualEnv *******************
sudo mkdir -p /var/www/python/agol_scripts /var/www/python/db_functions;
sudo chown -R jenkins:www-data /var/www/python;
sudo apt install python3.8-venv;
sudo su - jenkins;
mkdir .virtualenv;
cd .virtualenv;
python3 -m venv agol_scripts;
python3 -m venv db_functions;
. agol_scripts/bin/activate;


# *************************** PHP ****************************

sudo apt-get install software-properties-common;
yes "" | sudo add-apt-repository ppa:ondrej/php;
yes "" | sudo add-apt-repository ppa:ondrej/apache2;
sudo apt update;
yes | sudo apt install php;
yes | sudo apt install php8.0-simplexml php8.0-xmlreader php8.0-common php8.0-pdo-mysql php8.0-xml php8.0-curl php-imagick php8.0-pdo-pgsql php8.0-sysvmsg php8.0-xsl php8.0-pgsql php8.0-zip php8.0-mbstring php8.0-readline php8.0-gd php8.0-opcache;
sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/g'  /etc/php/8.0/apache2/php.ini;
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g'  /etc/php/8.0/apache2/php.ini;
sudo sed -i 's/post_max_size = 8M/post_max_size = 80M/g'  /etc/php/8.0/apache2/php.ini;
sudo service apache2 reload;


# ************************** Apache **************************

sudo apt-get install php-pgsql;
sudo systemctl restart apache2;
sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sudo apt install libjpeg62


# ************************** SSH ***************************
# this is only for changing the port that the instance is listening for ssh access
# sudo sed -i '11 i Port 56095' /etc/ssh/sshd_config;
# sudo service sshd restart || sudo service ssh restart


# ************************* Supervisor ****************************

sudo apt install supervisor;
sudo mv laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf;
sudo mkdir -p /var/www/html/api/storage/logs/;
cd /var/www/html/api/storage/logs/;
sudo touch agolworker.log telrworker.log gisworker.log trashworker.log;

sudo sed -i 's/chmod=0700/chmod=0770/g' /etc/supervisor/supervisord.conf;
sudo sed -i '6 i chown=root:jenkins' /etc/supervisor/supervisord.conf;


# ************************* Directories ****************************

cd /var/www/html/;
sudo mkdir -m 775 2nform api api_new ram report;
sudo chown jenkins:www-data 2nform api api_new ram report;
sudo mkdir api/storage/clockwork;
sudo chown jenkins:www-data api/storage/clockwork;
sudo chmod -R 775 api;

sudo supervisorctl reread;

sudo mkdir -p /var/www/html/api/storage/framework/;
cd /var/www/html/api/storage/framework/;
sudo mkdir sessions views cache;
sudo chown jenkins:www-data sessions views cache;

sudo reboot;


# ******************** Subdomains ******************
sudo a2enmod rewrite;
sudo systemctl restart apache2.service;

sudo apt install postgresql-client
sudo apt install unoconv
sudo apt-get install postgis
