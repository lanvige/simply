#! /bin/bash
 
### BEGIN INIT INFO
# Provides:          unicorn
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the unicorn web server
# Description:       starts unicorn
### END INIT INFO

# Change these to match your app:
USER=ares
APP_NAME=simply
APP_PATH="/home/$USER/apps"
ENV=production
RBENV_RUBY_VERSION=2.1.1

NAME=unicorn
DESC="Unicorn app for $APP_NAME"
APP_ROOT="$APP_PATH/$APP_NAME"
RBENV_ROOT="/home/$USER/.rbenv"
PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
DAEMON=unicorn
DAEMON_OPTS="-c $APP_ROOT/config/unicorn.rb -E $ENV -D"
PID=/home/$USER/$APP_NAME/tmp/pids/unicorn.pid


case "$1" in
  start)
        CD_TO_APP_DIR="cd $APP_ROOT"
        START_DAEMON_PROCESS="$DAEMON $DAEMON_OPTS"

        echo -n "Starting $DESC: "
        if [ `whoami` = root ]; then
          su -c "$CD_TO_APP_DIR > /dev/null 2>&1 && $START_DAEMON_PROCESS" - $USER 
        else
          $CD_TO_APP_DIR > /dev/null 2>&1 && $START_DAEMON_PROCESS
        fi
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        kill -QUIT `cat $PID`
        echo "$NAME."
        ;;
  restart)
        echo -n "Restarting $DESC: "
        kill -USR2 `cat $PID`
        echo "$NAME."
        ;;
  reload)
        echo -n "Reloading $DESC configuration: "
        kill -HUP `cat $PID`
        echo "$NAME."
        ;;
  *)
        echo "Usage: $NAME {start|stop|restart|reload}" >&2
        exit 1
        ;;
esac

exit 0