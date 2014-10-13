#Script to get the audit events
sleepTime=30

auditRoot=/opt/alfresco
find $auditRoot -name "audit-*.log" -type f -delete

while [ 1 ]
do
  now=`date +"%Y-%m-%d-%T"`
  auditLog=./audit-${now}.log
  rm $auditLog
  touch $auditLog
  fromTime=`date +"%s" -d -120seconds`000
  
  if test -z $lastId; then
    echo "from Time: $fromTime" 
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&fromTime=$fromTime&limit=10" >> $auditLog
    lastId=`grep id $auditLog | tail -1 | sed s/,// | tr -d "\n" | awk -F: '{print $2}'`
    lastId=$((lastId + 1))
  else
    echo "From Id: $lastId"
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&fromId=$lastId&limit=5000" >> $auditLog
    lastId=`grep id $auditLog | tail -1 | sed s/,// | tr -d "\n" | awk -F: '{print $2}'`
    lastId=$((lastId + 1))
    echo "To Id = $lastId"
  fi

  mv $auditLog $auditRoot

  #Siesta time
  sleep $sleepTime
  #Delete files older than 10 minutes
  find $auditRoot -name "audit-*.log" -type f -mmin +10 -delete
done
