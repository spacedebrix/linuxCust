# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt
color_prompt=yes

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

COLOR_WHITE='\033[037m'
COLOR_RED='\033[031m'
COLOR_YELLOW='\033[1;033m'
COLOR_NOCOLOR='\033[0m'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

git_prompt() {
    local git_status="$(git status 2> /dev/null)"

    if [[ $git_status =~ "Your branch is ahead of" ]]; then
        local color=$COLOR_RED
    else
        local color=$COLOR_WHITE
    fi

    local branch=$(parse_git_branch)
    if [[ $git_status =~ "modified:" || $git_status =~ "new file:" || $git_status =~ "deleted:" || $git_status =~ "renamed" ]]; then
        branch=$branch*
    fi

    if [[ $branch != "" ]]; then
        echo -ne " "$color[$branch]$COLOR_NOCOLOR
    fi
}

prompt_path() {
    echo `pwd` | awk -F '/' '{ if( length($0) > 38 ) { print ".../"$(NF-1)"/"$(NF) } else {print $0;} }' | sed "s|$HOME|~|"
}

#PS1="$COLOR_YELLOW\$ $COLOR_NOCOLOR\w\$(git_prompt)> "
PS1="$COLOR_YELLOW\$ $COLOR_NOCOLOR\$(prompt_path)\$(git_prompt)> "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Customization
function cd
{
   if [ $# -eq 0 ]; then
      DIR="${HOME}"
   else
      DIR="$1"
   fi

   builtin pushd "${DIR}" > /dev/null
}
alias b='pushd +1 > /dev/null'

. ~/.alias

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Help system
export HLP_LOC="$HOME/hlp/"
export HLP_INDEX_LOC="$HOME/hlp/index"
export HLP_FILES_LOC="$HOME/hlp/files/"

export PATH="$PATH:$HOME/bin:$HOME/bin/help"
