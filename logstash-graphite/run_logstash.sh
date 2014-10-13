if [ "$1" = "start" ] ; then
  echo "Starting logstash script"
  echo "Logging output to logstash.log"
  #Start processes in the background
  nohup bin/logstash -v agent -f logstash.conf &>logstash.log &
elif [ "$1" = "stop" ] ; then
  echo "Stopping logstash"
  #Terminate previous processes
  ps -ef | grep "jruby-complete-1.7.11.jar" | grep "logstash-graphite" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
else
  echo "Use run_logstash.sh <start|stop>"
fi
