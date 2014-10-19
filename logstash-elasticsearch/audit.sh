Script to get the audit events
sleepTime=30

auditRoot=/opt/alfresco
find $auditRoot/ -name "audit-*.log" -type f -delete

while [ 1 ]
do
  now=`date +"%Y-%m-%d-%T"`
  auditLog=./audit-${now}.log
  touch $auditLog
  fromTime=`date +"%s" -d -60seconds`000

  if test -z $lastId; then
    echo "from Time: $fromTime" 
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&limit=1000&fromTime=$fromTime" >> $auditLog
    lastId=`grep "\"id\":" $auditLog | tail -1 | sed s/,// | tr -d "\n" | awk -F: '{print $2}'`
    echo "To Id = $lastId"
  else
    echo "From Id: $lastId"
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&limit=1000&fromId=$lastId" >> $auditLog
    lastId=`grep "\"id\":" $auditLog | tail -1 | sed s/,// | tr -d "\n" | awk -F: '{print $2}'`
    echo "To Id = $lastId"
  fi

  mv $auditLog $auditRoot

  #Siesta time
  sleep $sleepTime
  #Delete files older than 1 hour
  find $auditRoot/ -name "audit-*.log" -type f -mmin +60 -delete
done
