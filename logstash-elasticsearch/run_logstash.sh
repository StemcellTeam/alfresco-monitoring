if [ "$1" = "start" ] ; then
  echo "Starting logstash and audit scripts"
  echo "Logging output to logstash.log and audit.log"
  #Start processes in the background
  nohup java -Xmx512m -jar logstash-1.1.13-flatjar.jar agent -f logstash.conf &>logstash.log &
  nohup ./audit.sh 1>audit.log &>audit.log &
elif [ "$1" = "stop" ] ; then
  echo "Stopping logstash and audit scripts"
  #Terminate previous processes
  ps -ef | grep "logstash-1.1.13-flatjar.jar agent -f logstash.conf" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  ps -ef | grep "/bin/sh ./audit.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
else
  echo "Use run_logstash.sh <start|stop>"
fi
