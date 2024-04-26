if status is-interactive
  # Commands to run in interactive sessions can go here

  # Atuin
  atuin init fish | source

  # RBenv
  ~/.rbenv/bin/rbenv init - fish | source
  fish_add_path -m ~/.rbenv/shims/

  # Add .local/bin to the PATH
  fish_add_path -m ~/.local/bin/

  # Rails
  alias be="bundle exec"
  alias bi="bundle install -j $(nproc)"
  alias rd="bin/dev"
  alias rs="bin/rails server"
  alias dbm="bin/rails db:migrate"
  alias dbr="bin/rails db:rollback"
  alias rg="bin/rails generate"
  alias rc="bin/rails console"

  # Run Docker Compose dev
  alias dcdev="docker compose -f docker-compose.dev.yml up"

  # Jekyll
  alias js="be jekyll s -H 0.0.0.0"

  # Git
  alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
  alias gd='git diff'
  alias ga='git add'
  alias gc='git commit'
  alias gca='git commit -a'
  alias gcam='git commit -am'
  alias gco='git checkout'
  alias gb='git branch'
  alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
  alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
  alias gsh="git rev-parse --short HEAD"
  alias gr="git remote -v"

  # Curl
  alias curlxml="curl -H 'Accept: application/xml' -H 'Content-type: application/xml' "
  alias curljson="curl -H 'Accept: application/json' -H 'Content-type: application/json' "

  # vhosts
  alias hosts='sudo nano /etc/hosts'

  # untar
  alias untar='tar xvf'
end
