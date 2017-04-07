#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
SCRIPTS="$DIR/scripts"

function usage {
  echo
  echo "Quickly start, stop or restart Intelora's esential services in detached screens"
  echo
  echo "usage: $0 [-h] (start [-v|-c]|stop|restart)"
  echo "      -h             this help message"
  echo "      start          starts intelora-service, intelora-skills, intelora-voice and intelora-cli in quiet mode"
  echo "      start -v       starts intelora-service, intelora-skills and intelora-voice"
  echo "      start -c       starts intelora-service, intelora-skills and intelora-cli in background"
  echo "      start -d       starts intelora-service and intelora skills in quiet mode and an active intelora-cli"
  echo "      stop           stops intelora-service, intelora-skills and intelora-voice"
  echo "      restart        restarts intelora-service, intelora-skills and intelora-voice"
  echo
  echo "screen tips:"
  echo "            run 'screen -list' to see all running screens"
  echo "            run 'screen -r <screen-name>' (e.g. 'screen -r intelora-service') to reatach a screen"
  echo "            press ctrl + a, ctrl + d to detace the screen again"
  echo "            See the screen man page for more details"
  echo
}

mkdir -p $DIR/logs

function verify-start {
    if ! screen -list | grep -q "$1";
    then
      echo "$1 failed to start. The log is below:"
      echo
      tail $DIR/logs/$1.log
    exit 1
    fi
}

function start-intelora {
  screen -mdS intelora-$1$2 -c $SCRIPTS/intelora-$1.screen $DIR/scripts/intelora-start.sh $1 $2
  sleep 1
  verify-start intelora-$1$2
  echo "Intelora $1$2 started"
}

function debug-start-intelora {
  screen -c $SCRIPTS/intelora-$1.screen $DIR/scripts/intelora-start.sh $1 $2
  sleep 1
  verify-start intelora-$1$2
  echo "Intelora $1$2 started"
}

function stop-intelora {
    if screen -list | grep -q "$1";
    then
      screen -XS intelora-$1 quit
      echo "Intelora $1 stopped"
    fi
}

function restart-intelora {
    if screen -list | grep -q "quiet";
    then
      $0 stop
      sleep 1
      $0 start
    elif screen -list | grep -q "cli" && ! screen -list | grep -q "quiet";
    then
      $0 stop
      sleep 1
      $0 start -c
    elif screen -list | grep -q "voice" && ! screen -list | grep -q "quiet";
    then
      $0 stop
      sleep 1
      $0 start -v
    else
      echo "An error occurred"
    fi
}

set -e

if [[ -z "$1" || "$1" == "-h" ]]
then
  usage
  exit 1
elif [[ "$1" == "start" && -z "$2" ]]
then
  start-intelora service
  start-intelora skills
  start-intelora voice
  start-intelora cli --quiet
  exit 0
elif [[ "$1" == "start" && "$2" == "-v" ]]
then
  start-intelora service
  start-intelora skills
  start-intelora voice
  exit 0
elif [[ "$1" == "start" && "$2" == "-c" ]]
then
  start-intelora service
  start-intelora skills
  start-intelora cli
  exit 0
elif [[ "$1" == "start" && "$2" == "-d" ]]
then
  start-intelora service
  start-intelora skills
  debug-start-intelora cli
  exit 0
elif [[ "$1" == "stop" && -z "$2" ]]
then
  stop-intelora service
  stop-intelora skills
  stop-intelora voice
  stop-intelora cli
  exit 0
elif [[ "$1" == "restart" && -z "$2" ]]
then
  restart-intelora
  exit 0
else
  usage
  exit 1
fi
