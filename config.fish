if status is-interactive
  # Commands to run in interactive sessions can go here

  # Atuin
  # atuin init fish | source

  # ASDF
  source ~/.asdf/asdf.fish

  # Add .local/bin to the PATH
  fish_add_path -m ~/.local/bin/

  # Rails
  alias be="bundle exec"
  alias bi="bundle install -j (nproc)"
  alias rd="bin/dev"
  alias rs="bin/rails server"
  alias dbm="bin/rails db:migrate"
  alias dbr="bin/rails db:rollback"
  alias rg="bin/rails generate"
  alias rc="bin/rails console"

  alias dcdev="docker compose -f docker-compose.dev.yml up"
  alias dc="docker compose"

  # Git
  alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
  alias gd='git diff'
  alias ga='git add'
  alias gc='git commit'
  alias gca='git commit -a'
  alias gcam='git commit -am'
  alias gco='git checkout'
  alias gb='git branch'
  alias gs='git status -sb'
  alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
  alias gsh="git rev-parse --short HEAD"
  alias gr="git remote -v"

  # vhosts
  alias hosts='sudo nano /etc/hosts'

  # untar
  alias untar='tar xvf'
end
