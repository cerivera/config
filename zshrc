# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#export PIP_REQUIRE_VIRTUALENV=true

export JSON_SCHEMA_TEST_SUITE=/Users/crivera/dev/vendor/JSON-Schema-Test-Suite

JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

alias cdu='cd ~/projects/ua'
alias cdp='cd ~/projects/ua/panama'
alias cdd='cd ~/projects/ua/svc_discover'
alias ez='vim ~/.zshrc'
alias ev='vim ~/.vimrc'
alias sz='source ~/.zshrc'
alias dm='docker-machine'
alias dco='docker-compose'
alias dk='docker'
alias dk-api-bash='dk exec -it $(docker ps | grep svcdiscover_api | tr -s " " | cut -d " " -f 1) /bin/bash'
alias py351='docker run --rm -i -t python:3.5.1 /bin/bash'
alias rm-localdev='docker-machine rm localdev'
alias new-localdev='docker-machine create localdev --driver virtualbox --virtualbox-cpu-count "4" --virtualbox-memory "4096" --virtualbox-disk-size "60000"'
alias env-localdev='eval $(docker-machine env localdev)'
alias dk-clean='docker images -aq -f dangling=true | xargs docker rmi --force && docker volume ls -qf dangling=true | xargs docker volume rm'
alias dk-mysql='mysql -uadmin -padmin -h$(dm ip localdev) -P23306'
alias dk-mysqldump='mysqldump -d -uadmin -padmin -h$(dm ip localdev) -P23306 discover > ~/projects/ua/svc_discover/docker/mysql/structure.sql'
alias dk-mysql-reset='dk-mysql -e "drop database discover; create database discover"'

if [ "$(dm status localdev)" = "Running" ]; then
    env-localdev
fi
export HISTFILESIZE=10000000

#### Go Service Tools (UACF)

# Show usage or update the go service tools
function goservicetools() {
  if [[ $1 == "-u" ]]; then
    echo "Updating tools to ~/.go_service_tools"
    curl --output ~/.go_service_tools https://cgit.uacf.io/go_build.git/plain/tools/.go_service_tools
    echo "Reloading ~/.go_service_tools"
    . ~/.go_service_tools
  else
    echo "Commands:"
    echo "  goinit                           Set the GOPATH the the root of the current git repo.  If not in a git repo, will set the GOPATH to the working directory"
    echo "  goreset                          Reset the local dependencies to those that are specified in dependencies.txt"
    echo "  gopin                            Mount local sources into the builder container and create dependencies.txt using the state of the local dependencies"
    echo "  godebug <service> [<procname>]   Attach gdb to a go process in a running container"
    echo "  gocover <service>                Extract code coverage report from a container and display the output in a browser."
    echo "  goservicetools [-u]              Show tools usage or update tools"
  fi
}

function goinit {
  # If we're inside a git repo then assume the git root is what we want to append
  GITROOT=`git rev-parse --show-toplevel 2> /dev/null`
  if [[ ! $GITROOT == "" ]]; then
    export GOPATH=$GITROOT
  else
    export GOPATH=`pwd`
  fi
  go env | grep GOPATH
}

function gopin() {
  docker run --rm -v `pwd`:/go/src/app/ docker.uacf.io/go_build/builder_1.4.2:master go-pin.sh freeze > dependencies.txt
}

function goreset() {
  docker run --rm -v `pwd`:/go/src/app/ docker.uacf.io/go_build/builder_1.4.2:master bash -c 'go-pin.sh reset < dependencies.txt'
}

function godebug() {
    local container=$1
    local proc=$2
    proc=${proc:=$container}

    echo "finding container..."
    local cid=$(docker ps | grep "${container}_1" | awk '{ print $1 }')
    echo "$cid"

    echo "finding process...."
    local psoutput=$(docker exec "$cid" ps -eaf | grep "$proc")
    echo "$psoutput"

    local pid=$(echo $psoutput | awk '{ print $2 }')
    echo "We think the PID is $pid"
    docker exec -it "$cid" gdb --quiet --init-eval-command "attach $pid"
}

function gocover() {
    local service=$1
    if [[ -z "$1" ]]; then
       echo "usage: gocover service"
       echo "    service - service name in docker-compose.yml"
    else
        html="$(docker-compose run --rm --no-deps $service bash -c 'cat coverage.html 2>/dev/null')"
        if [[ $? == 0 ]]; then
            if [[ ! $html == "" ]]; then
                echo -n "$html" > coverage.html
                open coverage.html
            else
                echo "coverage.html does not exist"
            fi
        fi
    fi
}

function gfb ()
{
	git co master && git pull && git fetch --prune && for b in `git branch --merged master | grep -v master`;
	do
		git branch -d $b;
	done
}

function reset_2fa ()
{
    ssh -t salt.uacf.io sudo ssh -t openvpnas@internal-vpn.uacf.io sudo /usr/local/openvpn_as/scripts/sacli --user $1 GoogleAuthRegen
}

function dk-clean-containers ()
{
    if [ -n "$(dk ps -q)" ]
    then
        dk stop $(dk ps -q)
    fi

    if [ -n "$(dk ps -aq)" ]
    then
        dk rm $(dk ps -aq)
    fi
}


function dk-clean-all ()
{
    docker_clean_containers

    if [ -n "$(dk images -q)" ]
    then
        dk rmi -f $(dk images -q)
    fi
}

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
