if [ -z "$GRAPHITE_DIR" ]; then
  echo "Please set GRAPHITE_DIR variable to the path of your logstash-graphite folder"
  echo "i.e. export GRAPHITE_DIR=<path>/logstash-graphite"
  exit
fi

dir=$GRAPHITE_DIR

if [ "$1" = "start" ] ; then
  echo "Starting logstash script"
  echo "Logging output to $GRAPHITE_DIR/logstash.log"
  #Start processes in the background
  nohup $dir/bin/logstash -v agent -f $GRAPHITE_DIR/logstash.conf &>$GRAPHITE_DIR/logstash.log &
elif [ "$1" = "stop" ] ; then
  echo "Stopping logstash"
  #Terminate previous processes
  ps -ef | grep "$GRAPHITE_DIR/lib/logstash/runner.rb" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
else
  echo "Use run_logstash.sh <start|stop>"
fi
