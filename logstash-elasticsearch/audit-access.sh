#Script to get audit access events
sleepTime=30

auditRoot=/opt/alfresco

while [ 1 ]
do
  now=`date +"%Y-%m-%d-%T"`
  auditLog=./auditLog/audit-access-${now}.log
  parsedAuditLog=audit-access-${now}.parsed
  touch $auditLog
  fromTime=`date +"%s" -d -60seconds`000

  if test -z $lastId; then
    echo "from Time: $fromTime" 
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&limit=5000&fromTime=$fromTime" >> $auditLog
    lastId=`grep "\"id\":" $auditLog | tail -1 | sed s/,// | tr -d "\n" | awk -F: '{print $2}'`
    echo "To Id = $lastId"
    lastId=$((lastId + 1))
  else
    echo "From Id: $lastId"
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&limit=5000&fromId=$lastId" >> $auditLog
    lastId=`grep "\"id\":" $auditLog | tail -1 | sed s/,// | tr -d "\n" | awk -F: '{print $2}'`
    echo "To Id = $lastId"
    lastId=$((lastId + 1))
  fi

  #Process the audit file
  java -jar ParseAuditFile.jar $auditLog > $auditRoot/$parsedAuditLog
  #Delete files older than 30 minutes
  find auditLog -name "audit-access-*.log" -type f -maxdepth 1 -mmin +30 -delete

  #Siesta time
  sleep $sleepTime
  #Delete files older than 30 minutes
  find $auditRoot/ -name "audit-access-*.parsed" -type f -maxdepth 1 -mmin +30 -delete
done
