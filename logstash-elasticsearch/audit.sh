#Script to get the audit events
sleepTime=60

auditRoot=/opt/alfresco
rm $auditRoot/audit-*.log

while [ 1 ]
do
  now=`date +"%Y-%m-%d-%T"`
  auditLog=/opt/alfresco/audit-${now}.log
  rm $auditLog
  touch $auditLog
  fromTime=`date +"%s" -d -120seconds`000
  toTime=`date +"%s"`000
  
  if test -z $lastId; then
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&fromTime=$fromTime&toTime=$toTime" >> $auditLog
  else
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&fromId=$lastId&limit=10000" >> $auditLog
  fi

  echo "from: $fromTime to: $toTime"
  lastId=`grep id $auditLog | tail -1 | sed s/,// | awk -F: '{print $2}' | tr -d "\n"`
  echo "Last Id = $lastId"
  #Siesta time
  sleep $sleepTime
  rm $auditLog
done
