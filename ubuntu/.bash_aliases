# Symlink this to your home folder, then you can run any of these aliases in your terminal.

# Tool quick start
api() {
  cd /var/www/html/api;
  composer install;
  php artisan migrate;
  composer freshtest;
  composer integrationtest;
  php artisan queue:flush;
  php artisan queue:listen;
}
ram() {
  cd /var/www/html/ram;
  npm ci;
  npm run notestgulp;
}
report() {
  cd /var/www/html/report;
  npm ci;
  npm run notestgulp;
}
2nform() {
  cd /var/www/html/2nform;
  npm ci;
  npm run gulp;
}
dbfunctions() {
  cd /var/www/python/db_functions;
  virtualenv;
  pip3 install -r requirements.txt;
  pytest;
}
agol() {
  cd /var/www/python/agol-scripts;
  virtualenv;
  pip3 install -r requirements.txt;
  pytest;
}

# Python
virtualenv() {
  mkdir .virtualenv -p;
  python3 -m venv ./.virtualenv;
  . ./.virtualenv/bin/activate;
}

# Docker, each command takes the ECR repository name as a parameter,
# so an example build might be `dockerbuild jenkins-manager`
dockerbuild() {
  sudo docker build --no-cache --force-rm --pull -t $1:latest .;
  sudo docker system prune --volumes --force;
}
dockerdeploy() {
  aws ecr get-login-password | sudo docker login --username AWS --password-stdin 269231215335.dkr.ecr.us-west-1.amazonaws.com;
  sudo docker tag $1 269231215335.dkr.ecr.us-west-1.amazonaws.com/$1;
  sudo docker push 269231215335.dkr.ecr.us-west-1.amazonaws.com/$1;
}
dockerrestart() {
  aws ecs update-service --cluster jenkins-cluster --service $1 --force-new-deployment --no-cli-pager;
  xdg-open https://us-west-1.console.aws.amazon.com/ecs/v2/clusters/jenkins-cluster/tasks?region=us-west-1 &
}

# Path additions
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Environment variables
# https://github.com/puppeteer/puppeteer/blob/v8.0.0/docs/api.md#environment-variables
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
