alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

alias a="LANG=en_US.UTF-8 atom --clear-window-state"
alias ade="LANG=de_DE.UTF-8 atom --clear-window-state"

alias d="docker"
alias doco="docker-compose"
alias dm="docker-machine"
alias doma="docker-machine"
function dme {
  eval $(docker-machine env $2 $1)
}
function dmuse {
  if [ "$1" = "mac" ]; then
    # Use Docker for Mac
    unset ${!DOCKER_*}
    echo "Now using Docker for Mac..."
  else
    # Start machine with given name
    doma start $1
    dme $@
  fi
}
alias dps='docker ps --format="table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'

alias g="git"
alias gti="git"
# Show state of all git repositories in a directory
function gitls {
  if [ "$#" -lt 1  ]; then
    dirs="."
  else
    dirs=$*
  fi
  if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      RED=$(tput setaf 1)
      ORANGE=$(tput setaf 172)
      GREEN=$(tput setaf 70)
      PURPLE=$(tput setaf 141)
    else
      GREEN=$(tput setaf 2)
      PURPLE=$(tput setaf 1)

    fi
    RESET=$(tput sgr0)
  else
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    RESET="\033[m"
  fi

  for d in `find $dirs -name ".git"`; do
    # check if we're in a git repo
    git --git-dir=$d --work-tree=$d/.. rev-parse --is-inside-work-tree &>/dev/null # || return

    # quickest check for what branch we're on
    branch=$(git --git-dir=$d --work-tree=$d/.. symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')

    # check if it's dirty (via github.com/sindresorhus/pure)
    dirty=$(git --git-dir=$d --work-tree=$d/.. diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ]&& echo -e "*")
    dir=`echo $d | sed -e 's|^\.\/||' -e 's|\/.git||'`
    FOLDER=$GREEN
    BRANCH=$GREEN
    if [ "$branch" != "master" ]; then
      FOLDER=$ORANGE
      BRANCH=$ORANGE
    fi
    if [ "$dirty" = "*" ]; then
      FOLDER=$RED
      BRANCH=$RED
    fi
    echo $RESET$FOLDER"$dir$RESET on "$BRANCH$branch$dirty$RESET
  done
}
alias gls="gitls"
function clone {
  repo="$1"
  shift
  git clone "git@github.com:$repo" "$@"
}
function add {
  git add "$@"
}
function amend {
  git commit --amend -m "$*"
}
function commit {
  git commit -m "$*"
}
function merge {
  git merge "$@"
}
function mergemaster {
  branch="$(currbranch)"
  git checkout master && git pull && git checkout "$branch" && git merge --no-edit master
}
alias prunebranches="git branch --merged master | grep -v ' master$' | xargs git branch -d"
alias pull="git pull"
# Print current branch
function currbranch {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
# Automatically set matching remote branch on first push
function push {
  if git branch -vv | grep '\*' | grep -q '\['; then
    git push
  else
    git push -u origin "$(currbranch)"
  fi
}
alias status="git status"
# Switch to branch and create it if necessary
function switch {
  if git branch -a | grep -q "$1"; then
    git checkout "$1"
  else
    git checkout -b "$1"
  fi
}

alias kc="kubectl"
function kca {
  kubectl "$@" --all-namespaces
}
# Set Kubernetes client to new namespace
function kcns {
  [ -n "$1" ] && kubectl config set-context --current --namespace="$1"
  kubectl config view | grep namespace:
}
# Set Kubernetes client to new context
function kcctx {
  [ -n "$1" ] && kubectl config use-context "$1"
  kubectl config get-contexts --no-headers | tr -s " " | cut -d " " -f1,2,5 | sed 's/ / | /g'
}

alias nr="npm run"
alias noss="cp ~/.npmrc-oss ~/.npmrc && npm cache clean -f"
alias npriv="cp ~/.npmrc-priv ~/.npmrc && npm cache clean -f"

alias v="vagrant"
alias vr="vagrant resume"
alias vs="vagrant suspend"

alias work="~/bin/workinghours/show.sh"
