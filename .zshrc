# .zshrc: Initialization file for interactive shell

ttyctl -u
stty intr  eof  quit  kill  stop  start  susp  erase 

# FIXME: freezing tty loses with xterm; arrow keys stop working
# ttyctl -f

# Set umask
umask 022

# If no terminal, use vt-100
if [[ -z "$TERM" || "$TERM" = "network" ]]; then
  export TERM=vt100
fi

# use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

function setenv { export $1=$2 }
case $OSTYPE in linux* | darwin* ) ;; * )
  function killall {
    case "$1" in -* ) sig=$1; shift ;; * ) sig=-TERM ;; esac
    case $OSTYPE in
      osf* )
        kill $sig `ps xua | g "^$USER " | grep "$@" | awk '{print $2}'` ;;
      * )
        kill $sig `ps -lu $USER | grep "$@" | awk '{print $4}'` ;;
    esac
  }
  ;;
esac

# Alter completion control - modify this to include your
# commonly used user@hostname pairs, or just @hostname.
myhosts=(@lx{voadm,plus}.cern.ch @cmslpc-sl5.fnal.gov @localhost)
myusers=($USER ${(u)${myhosts%%@*}})

function reset_userdirs {
  local u
  case $HOME in /afs/cern.ch/user/* )
    for u in $myusers; do
      hash -d $u="/afs/cern.ch/user/$u[1]/$u"
    done ;;
  esac
}

zstyle ':compinstall' filename "$HOME/.zshrc"
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '+m:{[a-zA-Z]}={[A-Za-z]}'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' preserve-prefix '/afs/[^/]##/' # no excess stat'ing /afs
zstyle ':completion:*' accept-exact-dirs true # avoid excess stat'ing /afs
zstyle ':completion:*:(^rm):*files' ignored-patterns '*(~|.(o|old|swp))'
case $OSTYPE in
 linux*) zstyle ':completion:*:processes' command 'ps xwfo pid,tty,time,command' ;;
 *)      zstyle ':completion:*:processes' command 'ps xwo pid,tty,time,command' ;;
esac
zstyle ':completion:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*:jobs' prefix-needed false
zstyle ':completion:*:hosts' hosts ${(u)${myhosts##*@}}
zstyle ':completion:*:my-accounts' users-hosts ${myhosts}
zstyle ':completion:*:users' users $myusers
autoload -Uz compinit
compinit
compdef _pids pystack
compdef _stgit stg

# force reduced $userdirs local to completion to avoid scanning all afs accounts
_comp_setup+=$'\ntypeset -a userdirs\nreset_userdirs'
reset_userdirs

# Set mail check interval; on cern the mailbox never contains anything
# and is on afs, possibly slowing things down -- so don't even bother
# checking it!
MAILCHECK=1000
LOGCHECK=0

# Variable settings
fpath=(~/bin/zutils $fpath)

# wanna have the history saved across sessions
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=10000

# Directory stack
DIRSTACKSIZE=50

# Emacs keyboard emulation
bindkey -d
bindkey -e
bindkey 'OA' up-line-or-history
bindkey 'OB' down-line-or-history
bindkey 'OC' forward-char
bindkey 'OD' backward-char

function chpwd { }

case X"$TERM:$TERM_PROGRAM" in
  Xxterm*:* | X*:Apple*) PROMPT='%{]0;%~ @ %m%}$ ';;
  Xdtterm:*)             PROMPT='%{]0;%~ @ %m%}$ ';;
  Xemacs:* | Xdumb:*)    PROMPT='$ ';;
  Xhp*:*)                PROMPT='%{&s1A%}$ '
                         bindkey '^[A' up-line-or-history
                         bindkey '^[B' down-line-or-history
                         bindkey '^[C' forward-char
                         bindkey '^[D' backward-char;;
  Xunknown:*)            PROMPT='$ ';;
  X*)                    PROMPT='%l %T %B%m%b[%h] %~: ';;
esac

# prompt on the right side of the screen
RPROMPT=''
PROMPT2=">"
PROMPT3="select: "
PROMPT4="+ "
TIMEFMT="Timing: %E[%*E] real, %U[%*U] user, %S[%*S] sys, %P CPU, %J"
TMOUT=0
WORDCHARS='*?.[]~&;\!#$%^(){}<>_-'

# Watch for friends
#watch=(msiren mta kaneli tlehto)
#WATCHFMT='%n %a %l from %m at %t.'

# Options

unsetopt ksh_option_print

setopt notify
setopt glob_dots
unsetopt bg_nice
unsetopt ignore_eof
setopt no_prompt_cr # Better in emacs

setopt append_history
setopt extended_history
setopt hist_no_store
setopt hist_ignore_space
setopt hist_expire_dups_first
setopt hist_ignore_dups
unsetopt hist_verify

setopt pushd_to_home
setopt pushd_ignore_dups
setopt pushd_silent
setopt auto_pushd
setopt pushd_minus

setopt auto_menu
unsetopt menu_complete
setopt complete_in_word
setopt mark_dirs
setopt list_types
setopt auto_list
setopt auto_cd
setopt cdable_vars
setopt no_no_match
unsetopt null_glob
setopt numeric_glob_sort

setopt correct
setopt correct_all

setopt rec_exact
setopt extended_glob
unsetopt no_clobber
setopt brace_ccl
unsetopt rm_star_silent

setopt long_list_jobs
setopt mail_warning
setopt auto_resume

setopt rc_quotes
setopt print_exit_value

unsetopt single_line_zle
setopt zle
setopt interactive_comments
setopt no_hup

[[ $EMACS = t ]] && unsetopt zle

##### EOF
