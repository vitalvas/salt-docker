# Setup a red prompt for root and a green one for users.
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u@\h [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$GREEN\u@\h [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi
