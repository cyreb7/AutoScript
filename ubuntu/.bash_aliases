# Symlink this to your home folder, then you can run any of these aliases in your terminal.
# alias commandYouTypeInTheTerminal="terminal commands run"

# Tool quick start
alias api="
  cd /var/www/html/api;
  composer install;
  php artisan migrate;
  composer freshtest;
  composer integrationtest;
  php artisan queue:flush;
  php artisan queue:listen;"
alias ram="
  cd /var/www/html/ram;
  npm ci;
  npm run notestgulp;"
alias report="
  cd /var/www/html/report;
  npm ci;
  npm run notestgulp;"
alias 2nform="
  cd /var/www/html/2nform;
  npm ci;
  npm run gulp;"
alias swtelrcli="
  cd /var/www/html/swtelr-cli;
  composer install;"
alias dbfunctions="
  cd /var/www/html/db_functions;
  source ~/.virtualenv/bin/activate;
  pip install -r requirements.txt;
  pytest"

# Do something to all repos
alias buildall="
  cd /var/www/html/ram; npm run gulp build &
  cd /var/www/html/report; npm run gulp build &
  cd /var/www/html/2nform; npm run gulp build &
  cd /var/www/html"
alias gitrefresh="
  cd /var/www/html/api;
  git checkout develop;
  git pull;
  git fetch --prune;
  git branch --merged develop | grep -v '^[ *]*develop$' | xargs git branch -d;

  cd /var/www/html/ram;
  git checkout develop;
  git pull;
  git fetch --prune;
  git branch --merged develop | grep -v '^[ *]*develop$' | xargs git branch -d;

  cd /var/www/html/report;
  git checkout develop;
  git pull;
  git fetch --prune;
  git branch --merged develop | grep -v '^[ *]*develop$' | xargs git branch -d;

  cd /var/www/html/2nform;
  git checkout develop;
  git pull;
  git fetch --prune;
  git branch --merged develop | grep -v '^[ *]*develop$' | xargs git branch -d;

  cd /var/www/html/swtelr-cli;
  git checkout develop;
  git pull;
  git fetch --prune;
  git branch --merged develop | grep -v '^[ *]*develop$' | xargs git branch -d;

  cd /var/www/html/db_functions;
  git checkout develop;
  git pull;
  git fetch --prune;
  git branch --merged develop | grep -v '^[ *]*develop$' | xargs git branch -d;
"

# Other helpers
alias ngrok="~/ngrok http 80"

# Path additions
# export PATH="$HOME/.config/composer/vendor/bin:$PATH"
