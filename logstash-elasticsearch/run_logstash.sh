if [ -z "$ELASTICSEARCH_DIR" ]; then
  echo "Please set ELASTICSEARCH_DIR variable to the path of your logstash-elasticsearch folder"
  echo "i.e. export ELASTICSEARCH_DIR=<path>/logstash-ealsticsearch"
  exit
fi

dir=$ELASTICSEARCH_DIR

if [ "$1" = "start" ] ; then
  echo "Starting logstash script"
  echo "Logging output to $ELASTICSEARCH_DIR/logstash.log"
  #Start processes in the background
  nohup $dir/bin/logstash -v agent -f $ELASTICSEARCH_DIR/logstash.conf &>$ELASTICSEARCH_DIR/logstash.log &
  nohup $dir/audit-access.sh &>$ELASTICSEARCH_DIR/audit-access.log &
  nohup $dir/audit-cmis.sh &>$ELASTICSEARCH_DIR/audit-cmis.log &
elif [ "$1" = "stop" ] ; then
  echo "Stopping logstash"
  #Terminate previous processes
  ps -ef | grep "$ELASTICSEARCH_DIR/lib/logstash/runner.rb" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  ps -ef | grep "$ELASTICSEARCH_DIR/audit-access.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  ps -ef | grep "$ELASTICSEARCH_DIR/audit-cmis.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
else
  echo "Use run_logstash.sh <start|stop>"
fi
