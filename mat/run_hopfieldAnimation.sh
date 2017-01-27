#!/bin/sh
# script for execution of deployed applications
#
# Sets up the MCR environment for the current $ARCH and executes 
# the specified command.
#
exe_name=$0
exe_dir=`dirname "$0"`
echo "------------------------------------------"
MCRROOT=$(which matlab)
MCRROOT=$(dirname $(dirname $MCRROOT))
echo "MCRROOT IS $MCRROOT"
if [ "x$1" = "x" ] && [ "$MCRROOT" = "" ] ; then
  echo Usage:
  echo    $0 \<deployedMCRroot\> args
else
  echo Setting up environment variables
  if [ "MCRROOT" = "" ] ; then
      MCRROOT="$1"
  fi 
  cd hopfieldAnimation/distrib
  ./run_hopfieldAnimation.sh $MCRROOT
fi
exit

