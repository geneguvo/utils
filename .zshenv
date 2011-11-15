# .zshenv: zsh environment settings (this is read always)

umask 022
USER=${USER:-$LOGNAME}
USER=${USER:-`whoami`}
export USER

if [[ -z "$SYS_PATH" ]]; then
  export SYS_PATH="$PATH"
  export SYS_MANPATH="$MANPATH"
  export SYS_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
  export SYS_DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH"
  export SYS_LIBPATH="$LIBPATH"
  export SYS_SHLIB_PATH="$SHLIB_PATH"

  export VISUAL=emacs
  export EDITOR=emacs
  export PAGER=less
  export SHORTHOST=${HOST%%.*}
  export LESS=MdeQXR
  export LESSCHARSET=utf-8
  export LESSOPEN="|lesspipe.sh %s"
  export CVS_RSH=ssh
  export CVSROOT=:ext:cmscvs.cern.ch:/cvs/CMSSW
  unset LD_LIBRARY_PATH DYLD_LIBRARY_PATH

  # Prevent HEPiX from changing environment
  if [ -d /etc/hepix ]; then
    _HPX_SEEN_HEPIX_SH=1
  fi

  if [ -d /pttools -a -z "$FMHOME" ]; then
    export PSRESOURCEPATH=/pttools/FrameMaker/Frame/fminit/fontdir::
    export FMHOME=/pttools/FrameMaker/Frame
  fi

  if [ -d /afs ]; then
    export CMS_PATH=/afs/cern.ch/cms
  fi

  if [ -d /etc/castor ]; then
    export STAGE_HOST=castorcms
    export RFIO_USE_CASTOR_V2=YES
    export CASTOR_HOME=/castor/cern.ch/user/$USER[0]/$USER
  fi

  export SCRATCH=/tmp/$USER
  export SGML_CATALOG_FILES=~/public/sgml/catalogs/docbook
  export SGML_CATALOG_FILES=$SGML_CATALOG_FILES:~/public/sgml/catalogs/dsssl
  export ORGANIZATION="Fermilab"
  # export TEXMFCNF=~/public/gnu/share/texmf/web2c
  # export TEXINPUTS=:/afs/cern.ch/group/zh/latex/styles
  unset XBMLANGPATH XFILESEARCHPATH NNTPSERVER ignoreeof

  case $OSTYPE in
   darwin* )
    export PATH=~/bin:/opt/local/bin:/opt/local/sbin:/bin:/usr/bin:/usr/sbin:/sbin
    export PATH=$PATH:/usr/local/bin:/usr/local/mysql/bin
    export MANPATH=$(manpath):/usr/local/mysql/man
    case =ls in
      /opt/* ) eval $(gdircolors | sed 's/do=[0-9;]*://'); LSCOLOR="--color=auto" ;;
      * )      LSCOLOR="-G" ;;
    esac
    ;;

   linux* )
    export PATH=~/bin:~/public/gnu/bin:/usr/sue/bin:/usr/kerberos/bin:/bin
    PATH=$PATH:/usr/bin:/sbin:/usr/sbin:/usr/bin/X11:/afs/cern.ch/sw/lisp/bin
    PATH=$PATH:/afs/cern.ch/cms/caf/scripts:/afs/cern.ch/cms/common
    PATH=$PATH:/usr/lib64/qt-3.3/bin:/usr/lib/qt-3.3/bin

    export MANPATH=~/man:/usr/share/man
    ;;

   solaris* )
    export PATH=~/bin:~/bin/sys:~/public/gnu/bin:/usr/local/bin/gnu:/usr/sue/bin:/usr/sbin
    PATH=$PATH:/opt/SUNWspro/bin
    PATH=$PATH:/usr/ccs/bin:/usr/bin:/usr/openwin/bin:/ust/dt/bin:/usr/ucb:/usr/local/bin
    PATH=$PATH:/usr/local/bin/X11:/cern/pro/bin:/pttools/FrameMaker/Frame/bin
    PATH=$PATH:/afs/cern.ch/cms/utils:/afs/cern.ch/cms/bin/@sys

    export MANPATH=~/man:/usr/sue/man:/opt/SUNWspro/man:/usr/man
    MANPATH=$MANPATH:/usr/openwin/man:/usr/dt/man:/usr/local/man
    MANPATH=$MANPATH:/cern/man:/afs/cern.ch/cms/cmsim/man

    export LD_LIBRARY_PATH=/opt/SUNWspro/lib:/usr/openwin/lib:/usr/dt/lib:/usr/local/lib
    ;;
  esac
fi

noalias() { false && echo "alias: ignoring '$*'" > /dev/tty; }
alias a=alias
case $OSTYPE:$TERM in *:dumb ) ;; * ) a ls="ls ${LSCOLOR---color=auto}" ;; esac
a l='ls -CF'
a ll='ls -CFa'
a L='ls -lF'
a LL='ls -lFa'
a p='pine -z -i -d 0'
a bindkey='noglob bindkey'
a grep=egrep
a g=egrep
a pg='\grep -P'
a h=history
a m=less
a j=jobs
a f=finger
a pop=popd
a e=emacs
a z=suspend
a savehist='fc -WI'
a unsetenv=unset
a screen='screen -T $TERM'
[ -f /usr/bin/vim ] && a vi=vim
wn () { echo -n "]0;$*" }

# Prevent loading system level aliases read after this
case $OSTYPE:$HOME in linux*:/afs/cern.ch/* )
 a alias=noalias ;;
esac

### EOF
